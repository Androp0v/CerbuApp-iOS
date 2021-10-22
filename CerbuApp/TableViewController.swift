//
//  ListViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SQLite3
import CoreSpotlight
import MobileCoreServices
import SwiftUI

struct OrlaView: View {

    @State var showFilters = false
    @State var filtersIconName = "line.horizontal.3.decrease.circle"

    var body: some View {
        OrlaViewContent()
            .navigationBarTitle("Orla Colegial")
            .globalNavigationBarColor()
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                Button(action: {
                    showFilters.toggle()
                }) {
                    Image(systemName: filtersIconName)
                        .font(Font.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white)
                }
                // Listen for filters off toggle
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FILTERS_OFF"))) { obj in
                   filtersIconName = "line.horizontal.3.decrease.circle"
                }
                // Listen for filters on toggle
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FILTERS_ON"))) { obj in
                   filtersIconName = "line.horizontal.3.decrease.circle.fill"
                }
                // Present sheet on button tap
                .sheet(isPresented: $showFilters) {
                    FiltersView()
                }
            }
    }
}
/// Wrapper to present the view  inside a SwiftUI view
struct OrlaViewContent: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OrlaView")
    }

    func presentFiltersModal() {
        // Do nothing for now
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! DetailsViewHostingController).personIndex
        
        if index > 0 {
            let selectedPerson: Person
            if searchActive{
                selectedPerson = filteredPeople[index - 1]
            }else{
                selectedPerson = People[index - 1]
            }
            let detailedController = DetailsViewHostingController(person: selectedPerson, index: index - 1)
            
            return detailedController
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! DetailsViewHostingController).personIndex

        let selectedPerson: Person
        if searchActive{
            if index < (filteredPeople.count - 1) {
                selectedPerson = filteredPeople[index + 1]
            } else {
                return nil
            }
        }else{
            if index < (People.count - 1) {
                selectedPerson = People[index + 1]
            } else {
                return nil
            }
        }
        let detailedController = DetailsViewHostingController(person: selectedPerson, index: index + 1)
        return detailedController
    }

    var People = [Person]()
    var filteredPeople = [Person]()
    var db: OpaquePointer?
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive = false
    var isRemovingTextWithBackspace = false
    let defaults = UserDefaults.standard
    var footerView = UIView()
    var footerLabel = UILabel()
    var selectedIndex: Int?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterStatus: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: -0.5, left: 0, bottom: 0, right: 0)
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Add footer label
        footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        footerLabel.textAlignment = .center
        footerLabel.textColor = UIColor.secondaryLabel
        footerView.addSubview(footerLabel)
        self.tableView.tableFooterView = footerView
        self.tableView.tableFooterView?.addSubview(footerLabel)
        
        // Adjust UITableView insets for footer
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        self.tableView.contentInset = insets
        
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(TableViewController.onSegmentedControlHapticFeedback(sender:)), for:.valueChanged)
        
        copyDatabaseIfNeeded()
        
        let fileManager = FileManager.default
        
        let databaseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        let finalDatabaseURL = databaseURL.first!.appendingPathComponent("database.db")
        
        if sqlite3_open(finalDatabaseURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
       
        loadPeopleFromDatabase()
        
        searchBar.delegate = self
        
        //This migh not be needed (iOS 13 bug?)
        tableView.reloadData()
        updateFooter()
        
        self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at:
            UITableView.ScrollPosition.top, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListOnChange), name: NSNotification.Name(rawValue: "DATABASE_CHANGED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filtersOnIconChange), name: NSNotification.Name(rawValue: "FILTERS_ON"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filtersOffIconChange), name: NSNotification.Name(rawValue: "FILTERS_OFF"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let willSelectIndex = selectedIndex else { return }
        tableView.selectRow(at: NSIndexPath(row: willSelectIndex, section: 0) as IndexPath, animated: false, scrollPosition: .none)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }) { context in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if searchActive{
            //searchBar.becomeFirstResponder()
            let reloadString = self.searchBar.text
            self.searchBar(self.searchBar, textDidChange: reloadString ?? "")
        }

        // FIXME: Re-enable avoiding memory issues
        /*DispatchQueue.global(qos: .userInitiated).async {
            self.loadDataForSpotlightIndexing()
        }*/
    }
    
    func updateFooter() {
        // Update footer asynchronously to avoid slowing the TableView
        DispatchQueue.main.async {
            
            var footerText: String = String()
            var peopleCount: Int = 0
            var peopleString: String = "personas"
            var favCount: Int = 0
            var favString: String = "favoritos"
            var becaCount: Int = 0
            var becaString: String = "adjuntos"
            
            if self.searchActive {
                peopleCount = self.filteredPeople.count
                favCount = self.filteredPeople.filter{ $0.liked }.count
                becaCount = self.filteredPeople.filter{ $0.beca != "" }.count
            } else {
                peopleCount = self.People.count
                favCount = self.People.filter{ $0.liked }.count
                becaCount = self.People.filter{ $0.beca != "" }.count
            }
            
            // Make strings singular if there's only one match
            if peopleCount == 1 {
                peopleString = "persona"
            }
            if favCount == 1 {
                favString = "favorito"
            }
            if becaCount == 1 {
                becaString = "adjunto"
            }
            
            // Set footer text
            footerText = String(peopleCount) + " " + peopleString + " (" + String(favCount) + " " + favString + ", " + String(becaCount) + " " + becaString + ")"
            
            self.footerLabel.text = footerText
        }
    }
        
    func CutCircleOnUIImage(startingImage: UIImage) -> UIImage {
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(startingImage.size)
        let context = UIGraphicsGetCurrentContext()!

        // Draw the starting image in the current context as background
        let Rect: CGRect = CGRect(x: 0, y: 0, width: min(startingImage.size.width,startingImage.size.height), height: min(startingImage.size.width,startingImage.size.height))
        let bezierPath = UIBezierPath(roundedRect: Rect, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: min(startingImage.size.width,startingImage.size.height),height: min(startingImage.size.width,startingImage.size.height)))
        context.addPath(bezierPath.cgPath)
        context.clip()
        
        context.drawPath(using: .fillStroke)
        startingImage.draw(in: Rect)

        // Save the context as a new UIImage
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Return modified image
        return circleImage
    }
    
    func loadDataForSpotlightIndexing(){
        var searchableItems = [CSSearchableItem]()
        
        //this is our select query
        let queryString = "SELECT * FROM colegiales"
        
        //Perform collation on database
        
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //Empty the people list
        var IndexablePeople = [Person]()
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let surname_1 = String(cString: sqlite3_column_text(stmt, 2))
            let surname_2 = String(cString: sqlite3_column_text(stmt, 3))
            let career = String(cString: sqlite3_column_text(stmt, 4))
            let room = String(cString: sqlite3_column_text(stmt, 5))
            
            var beca = String("")
            if sqlite3_column_text(stmt, 6) != nil{
                beca = String(cString: sqlite3_column_text(stmt, 6))
            }
            
            let likeTMP = sqlite3_column_int(stmt, 7)
            var like = false
            if likeTMP != 0{
                like = true
            }else{
                like = false
            }
            
            let floor = sqlite3_column_int(stmt, 8)
            let gender = sqlite3_column_int(stmt, 10)
            
            //adding values to list
            IndexablePeople.append(Person(id: Int(id), name: name, surname_1: surname_1, surname_2: surname_2, career: career, beca: beca, room: room, floor: Int(floor), liked: like, gender: Int(gender))!)
        }
        
        for i in 0...(IndexablePeople.count - 1){
            
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchableItemAttributeSet.title = IndexablePeople[i].name + " " + IndexablePeople[i].surname_1 + " " + IndexablePeople[i].surname_2
            
            if IndexablePeople[i].beca.isEmpty {
                searchableItemAttributeSet.contentDescription = IndexablePeople[i].career

            }else{
                searchableItemAttributeSet.contentDescription = IndexablePeople[i].career + " | " + IndexablePeople[i].beca
            }
            
            let icon = UIImage(named: (cleanString(rawString: IndexablePeople[i].name+IndexablePeople[i].surname_1))) ?? UIImage(named: (cleanString(rawString: IndexablePeople[i].name+IndexablePeople[i].surname_1+IndexablePeople[i].surname_2))) ?? UIImage(named: "nohres")!
            
            searchableItemAttributeSet.thumbnailData = (CutCircleOnUIImage(startingImage: icon).pngData())
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.raulmonton.CerbuApp.\(i)", domainIdentifier: "people", attributeSet: searchableItemAttributeSet)

            searchableItems.append(searchableItem)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return filteredPeople.count
        }else{
            return People.count
        }
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
    
        let person: Person
        if searchActive {
            person = filteredPeople[indexPath.row]
        } else {
            person = People[indexPath.row]
        }
    
        cell.nameLabel.text = person.name + " " + person.surname_1 + " " + person.surname_2
    
        let iconPhoto = UIImage(named: (cleanString(rawString: person.name+person.surname_1))) ?? UIImage(named: (cleanString(rawString: person.name+person.surname_1+person.surname_2))) ?? UIImage(named: "nohres")!
    
        cell.orlaImageView.image = iconPhoto
    
        if person.beca.isEmpty {
            cell.careerLabel.text = person.career
            if person.liked{
                cell.statusImageView.image = UIImage(named: "HotIcon")
            }else{
                cell.statusImageView.image = nil
            }
        }else{
            cell.careerLabel.text = person.career + " | " + person.beca
            if person.liked{
                cell.statusImageView.image = UIImage(named: "HotBecarioIcon")
            }else{
                cell.statusImageView.image = UIImage(named: "becario")
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row

        guard let selectedIndex = selectedIndex else {
            return
        }

        let detailedPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPageView") as! DetailsPageViewController
        detailedPageViewController.viewControllerIndex = selectedIndex
        detailedPageViewController.dataSource = self

        let selectedPerson: Person
        if searchActive{
            selectedPerson = filteredPeople[selectedIndex]
        }else{
            selectedPerson = People[selectedIndex]
        }

        let detailedController = DetailsViewHostingController(person: selectedPerson, index: selectedIndex)

        detailedPageViewController.setViewControllers([detailedController], direction: .forward, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(detailedPageViewController, animated: true)
        self.searchBar.resignFirstResponder()
        // FIXME: This
        /*DispatchQueue.main.async {
            self.performSegue(withIdentifier: "pushFromCell", sender: indexPath)
            self.searchBar.resignFirstResponder()
        }*/
    }
    
    
    // MARK: - Navigation

    // FIXME:
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if (segue.identifier == "pushFromCell") {
            let controller = (segue.destination as! DetailsPageViewController)
            let row = (sender as! NSIndexPath).row
            
            controller.viewControllerIndex = row
            controller.dataSource = self
            
            let detailedController = self.storyboard?.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
            let selectedPerson: Person
            if searchActive{
                selectedPerson = filteredPeople[row]
            }else{
                selectedPerson = People[row]
            }
            detailedController.detailedPerson = selectedPerson
            detailedController.pageIndex = row
            
            controller.setViewControllers([detailedController], direction: .forward, animated: true, completion: nil)
            
            /*let controller = (segue.destination as! DetailsViewController)
            let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
            let selectedPerson: Person
            if searchActive{
                selectedPerson = filteredPeople[row]
            }else{
                selectedPerson = People[row]
            }
            controller.detailedPerson = selectedPerson*/
        }
    }*/
    
    
    //MARK: Private Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        filteredPeople = [Person]()
        let cleanedSearchString = cleanStringWithWhitespaces(rawString: searchText)
        let searchWordsArray = cleanedSearchString.components(separatedBy: " ")
        var approvedFlag = false
        
        for person in People {
            approvedFlag = false
            for i in 0..<searchWordsArray.count {
                if cleanStringWithWhitespaces(rawString: person.name).hasPrefix(searchWordsArray[i])
                || cleanStringWithWhitespaces(rawString: person.surname_1).hasPrefix(searchWordsArray[i])
                || cleanStringWithWhitespaces(rawString: person.surname_2).hasPrefix(searchWordsArray[i])
                || cleanStringWithWhitespaces(rawString: person.career).hasPrefix(searchWordsArray[i])
                || cleanStringWithWhitespaces(rawString: person.beca).hasPrefix(searchWordsArray[i]){
                    approvedFlag = true
                }else{
                    approvedFlag = false
                    var tmpString = searchWordsArray[i]
                    
                    for j in 1..<(i+1){
                        tmpString = searchWordsArray[i-j] + " " + tmpString
                        
                        if cleanStringWithWhitespaces(rawString: person.name).hasPrefix(tmpString)
                            || cleanStringWithWhitespaces(rawString: person.surname_1).hasPrefix(tmpString)
                            || cleanStringWithWhitespaces(rawString: person.surname_2).hasPrefix(tmpString)
                            || cleanStringWithWhitespaces(rawString: person.career).hasPrefix(tmpString)
                            || cleanStringWithWhitespaces(rawString: person.beca).hasPrefix(tmpString){
                            
                            approvedFlag = true
                            break
                        }
                    }
                }
                
                let showRooms = defaults.bool(forKey: "showRooms")
                if showRooms{
                    if person.room.hasPrefix(searchWordsArray[i]){
                        approvedFlag = true
                    }
                }
                
                if !approvedFlag{
                    break
                }
            }
            
            if approvedFlag{
                filteredPeople.append(person)
            }
            
        }
        
        self.tableView.reloadData()
        updateFooter()
        
        if searchText.count == 0 && !isRemovingTextWithBackspace{
            self.searchActive = false
            self.searchBar.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.searchBar.resignFirstResponder()
            }
            return
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        filteredPeople = People
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        isRemovingTextWithBackspace = text.isEmpty
        return true
    }
    
    @objc func reloadListOnChange(notification: NSNotification){
        self.tableView.reloadData()
        updateFooter()
    }
    
    @objc func filtersOnIconChange(notification: NSNotification){
        self.filterStatus.image = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
        filterWithConstraints()
    }
    
    @objc func filtersOffIconChange(notification: NSNotification){
        self.filterStatus.image = UIImage(systemName: "line.horizontal.3.decrease.circle")
        cleanFilters()
    }
    
    func filterWithConstraints(){
        
        cleanFilters()
        
        if defaults.bool(forKey: "soloAdjuntos"){
            for (index, person) in People.enumerated().reversed(){
                if person.beca.isEmpty{
                    People.remove(at: index)
                }
            }
        }
        
        if defaults.bool(forKey: "soloFavoritos"){
            for (index, person) in People.enumerated().reversed(){
                if !person.liked{
                    People.remove(at: index)
                }
            }
        }
        
        if !defaults.bool(forKey: "male"){
            for (index, person) in People.enumerated().reversed(){
                if person.gender == 0{
                    People.remove(at: index)
                }
            }
        }
        
        if !defaults.bool(forKey: "female"){
            for (index, person) in People.enumerated().reversed(){
                if person.gender == 1{
                    People.remove(at: index)
                }
            }
        }
        
        if !defaults.bool(forKey: "nbothers"){
            for (index, person) in People.enumerated().reversed(){
                if person.gender > 1{
                    People.remove(at: index)
                }
            }
        }
                
        if !defaults.bool(forKey: "100s"){
            for (index, person) in People.enumerated().reversed(){
                if person.floor == 100{
                    People.remove(at: index)
                }
            }
        }
        
        if !defaults.bool(forKey: "200s"){
            for (index, person) in People.enumerated().reversed(){
                if person.floor == 200{
                    People.remove(at: index)
                }
            }
        }
        
        if !defaults.bool(forKey: "300s"){
            for (index, person) in People.enumerated().reversed(){
                if person.floor == 300{
                    People.remove(at: index)
                }
            }
        }
        
        if !defaults.bool(forKey: "400s"){
            for (index, person) in People.enumerated().reversed(){
                if person.floor == 400{
                    People.remove(at: index)
                }
            }
        }
        
        if searchActive{
            if defaults.bool(forKey: "soloAdjuntos"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.beca.isEmpty{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if defaults.bool(forKey: "soloFavoritos"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if !person.liked{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if !defaults.bool(forKey: "male"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.gender == 0{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if !defaults.bool(forKey: "female"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.gender == 1{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if !defaults.bool(forKey: "nbothers"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.gender > 1{
                        filteredPeople.remove(at: index)
                    }
                }
            }
                    
            if !defaults.bool(forKey: "100s"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.floor == 100{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if !defaults.bool(forKey: "200s"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.floor == 200{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if !defaults.bool(forKey: "300s"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.floor == 300{
                        filteredPeople.remove(at: index)
                    }
                }
            }
            
            if !defaults.bool(forKey: "400s"){
                for (index, person) in filteredPeople.enumerated().reversed(){
                    if person.floor == 400{
                        filteredPeople.remove(at: index)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
        updateFooter()
    }
    
    func cleanFilters(){
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                loadPeopleFromDatabase()
            default:
                loadPeopleFromDatabaseProm(promotion: segmentedControl.selectedSegmentIndex)
        }
        
        if searchActive{
            filteredPeople = People
            let reloadString = searchBar.text
            self.searchBar(self.searchBar, textDidChange: reloadString ?? "")
        }
        
        self.tableView.reloadData()
        updateFooter()
    }
    
    @objc func onSegmentedControlHapticFeedback(sender: UISegmentedControl){
        let feedbackGenerator = UISelectionFeedbackGenerator.init()
        feedbackGenerator.prepare()
        
        let reloadString = searchBar.text
        
        //This will also handle loading promotion data from SQL database (it calls loadPeopleDatabaseProm)
        filterWithConstraints()

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateFooter()
        }
        
        if searchActive{
            self.searchBar(self.searchBar, textDidChange: reloadString ?? "")
        }
        
        feedbackGenerator.selectionChanged()
    }
    
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("database.db")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let databaseURL = Bundle.main.resourceURL?.appendingPathComponent("database.db")
            
            do {
                try fileManager.copyItem(atPath: (databaseURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        
    }
    
    func cleanString(rawString: String) -> String{
        var cleanString = rawString
        cleanString = cleanString.lowercased()
        
        cleanString = cleanString.replacingOccurrences(of: " ", with: "")
        cleanString = cleanString.replacingOccurrences(of: "á", with: "a")
        cleanString = cleanString.replacingOccurrences(of: "é", with: "e")
        cleanString = cleanString.replacingOccurrences(of: "í", with: "i")
        cleanString = cleanString.replacingOccurrences(of: "ó", with: "o")
        cleanString = cleanString.replacingOccurrences(of: "ú", with: "u")
        cleanString = cleanString.replacingOccurrences(of: "ü", with: "u")
        cleanString = cleanString.replacingOccurrences(of: "ñ", with: "n")
        cleanString = cleanString.replacingOccurrences(of: "ç", with: "c")
        return cleanString
    }
    
    func cleanStringWithWhitespaces(rawString: String) -> String{
        var cleanString = rawString
        cleanString = cleanString.lowercased()
        
        cleanString = cleanString.replacingOccurrences(of: "á", with: "a")
        cleanString = cleanString.replacingOccurrences(of: "é", with: "e")
        cleanString = cleanString.replacingOccurrences(of: "í", with: "i")
        cleanString = cleanString.replacingOccurrences(of: "ó", with: "o")
        cleanString = cleanString.replacingOccurrences(of: "ú", with: "u")
        cleanString = cleanString.replacingOccurrences(of: "ü", with: "u")
        cleanString = cleanString.replacingOccurrences(of: "ñ", with: "n")
        cleanString = cleanString.replacingOccurrences(of: "ç", with: "c")
        return cleanString
    }
    
    private func loadPeopleFromDatabase(){
                
        //this is our select query
        let queryString = "SELECT * FROM colegiales"
        
        //Perform collation on database
        
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //Empty the people list
        People = [Person]()
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let surname_1 = String(cString: sqlite3_column_text(stmt, 2))
            let surname_2 = String(cString: sqlite3_column_text(stmt, 3))
            let career = String(cString: sqlite3_column_text(stmt, 4))
            let room = String(cString: sqlite3_column_text(stmt, 5))
            
            var beca = String("")
            if sqlite3_column_text(stmt, 6) != nil{
                beca = String(cString: sqlite3_column_text(stmt, 6))
            }
            
            let likeTMP = sqlite3_column_int(stmt, 7)
            var like = false
            if likeTMP != 0{
                like = true
            }else{
                like = false
            }
            
            let floor = sqlite3_column_int(stmt, 8)
            let gender = sqlite3_column_int(stmt, 10)
            
            //adding values to list
            People.append(Person(id: Int(id), name: name, surname_1: surname_1, surname_2: surname_2, career: career, beca: beca, room: room, floor: Int(floor), liked: like, gender: Int(gender))!)
        }
        
        if defaults.bool(forKey: "surnameFirst"){
            People = People.sorted { $0.surname_1.localizedCaseInsensitiveCompare($1.surname_1) == ComparisonResult.orderedAscending }
        }else{
            People = People.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        }
        
    }
    
    private func loadPeopleFromDatabaseProm(promotion: Int){
                
        //this is our select query
        var queryString = String()
        if promotion == 5 {
            queryString = "SELECT * FROM colegiales WHERE promotions >= " + String(promotion)
        } else {
            queryString = "SELECT * FROM colegiales WHERE promotions = " + String(promotion)
        }
        
        //Perform collation on database
        
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //Empty the people list
        People = [Person]()
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let surname_1 = String(cString: sqlite3_column_text(stmt, 2))
            let surname_2 = String(cString: sqlite3_column_text(stmt, 3))
            let career = String(cString: sqlite3_column_text(stmt, 4))
            let room = String(cString: sqlite3_column_text(stmt, 5))
            
            var beca = String("")
            if sqlite3_column_text(stmt, 6) != nil{
                beca = String(cString: sqlite3_column_text(stmt, 6))
            }
            
            let likeTMP = sqlite3_column_int(stmt, 7)
            var like = false
            if likeTMP != 0{
                like = true
            }else{
                like = false
            }
            
            let floor = sqlite3_column_int(stmt, 8)
            let gender = sqlite3_column_int(stmt, 10)
            
            //adding values to list
            People.append(Person(id: Int(id), name: name, surname_1: surname_1, surname_2: surname_2, career: career, beca: beca, room: room, floor: Int(floor), liked: like, gender: Int(gender))!)
        }
        
        if defaults.bool(forKey: "surnameFirst"){
            People = People.sorted { $0.surname_1.localizedCaseInsensitiveCompare($1.surname_1) == ComparisonResult.orderedAscending }
        } else {
            People = People.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        }
        
    }

}
