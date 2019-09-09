//
//  ListViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SQLite3

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var People = [Person]()
    var filteredPeople = [Person]()
    var db: OpaquePointer?
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive = false
    var isRemovingTextWithBackspace = false
    let defaults = UserDefaults.standard
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterStatus: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: -0.5,left: 0,bottom: 0,right: 0)
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        
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
        
        self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at:
            UITableView.ScrollPosition.top, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListOnChange), name: NSNotification.Name(rawValue: "DATABASE_CHANGED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filtersOnIconChange), name: NSNotification.Name(rawValue: "FILTERS_ON"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filtersOffIconChange), name: NSNotification.Name(rawValue: "FILTERS_OFF"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if searchActive{
            searchBar.becomeFirstResponder()
            let reloadString = self.searchBar.text
            self.searchBar(self.searchBar, textDidChange: reloadString ?? "")
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
        cell.orlaImageView.image = person.iconPhoto
    
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
        tableView .deselectRow(at: indexPath, animated: true)
        
        
        // Create an instance of DetailViewController and pass the variable
        //let destinationViewController = DetailsViewController()
        //destinationViewController.detailedPerson = selectedPerson
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "pushFromCell", sender: indexPath)
            self.searchBar.resignFirstResponder()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if (segue.identifier == "pushFromCell") {
            let controller = (segue.destination as! DetailsViewController)
            let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
            let selectedPerson: Person
            if searchActive{
                selectedPerson = filteredPeople[row]
            }else{
                selectedPerson = People[row]
            }
            controller.detailedPerson = selectedPerson
        }
    }
    
    
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
                
                if !approvedFlag{
                    break
                }
            }
            
            if approvedFlag{
                filteredPeople.append(person)
            }
            
        }
        
        self.tableView.reloadData()
        
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
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        isRemovingTextWithBackspace = text.isEmpty
        return true
    }
    
    @objc func reloadListOnChange(notification: NSNotification){
        self.tableView.reloadData()
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
        
        //Floor section is multiple choice
                
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
        
        self.tableView.reloadData()
    }
    
    func cleanFilters(){
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                loadPeopleFromDatabase()
            default:
                loadPeopleFromDatabaseProm(promotion: segmentedControl.selectedSegmentIndex)
        }
        
        self.tableView.reloadData()
    }
    
    @objc func onSegmentedControlHapticFeedback(sender: UISegmentedControl){
        let feedbackGenerator = UISelectionFeedbackGenerator.init()
        feedbackGenerator.prepare()
        let selectedSegment = segmentedControl.selectedSegmentIndex
        
        let reloadString = searchBar.text
        
        switch selectedSegment {
            case 0:
                loadPeopleFromDatabase()
            default:
                loadPeopleFromDatabaseProm(promotion: selectedSegment)
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        return cleanString
    }
    
    private func loadPeopleFromDatabase(){
        
        let photo1 = UIImage(named: "nohres")!
        
        //this is our select query
        let queryString = "SELECT * FROM colegiales ORDER BY names"
        
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
            //let _promotion = sqlite3_column_int(stmt, 9)
            let iconPhoto = UIImage(named: (cleanString(rawString: name+surname_1))) ?? photo1
            
            //adding values to list
            People.append(Person(id: Int(id), name: name, surname_1: surname_1, surname_2: surname_2, career: career, beca: beca, room: room, floor: Int(floor), iconPhoto: iconPhoto, liked: like)!)
        }
        
        if defaults.bool(forKey: "surnameFirst"){
            People = People.sorted { $0.surname_1.localizedCaseInsensitiveCompare($1.surname_1) == ComparisonResult.orderedAscending }
        }else{
            People = People.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        }
        
    }
    
    private func loadPeopleFromDatabaseProm(promotion: Int){
        
        let photo1 = UIImage(named: "nohres")!
        
        //this is our select query
        let queryString = "SELECT * FROM colegiales WHERE promotions = " + String(promotion) + " ORDER BY names"
        
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
            //let _promotion = sqlite3_column_int(stmt, 9)
            let iconPhoto = UIImage(named: (cleanString(rawString: name+surname_1))) ?? photo1
            
            //adding values to list
            People.append(Person(id: Int(id), name: name, surname_1: surname_1, surname_2: surname_2, career: career, beca: beca, room: room, floor: Int(floor), iconPhoto: iconPhoto, liked: like)!)
        }
        
        if defaults.bool(forKey: "surnameFirst"){
            People = People.sorted { $0.surname_1.localizedCaseInsensitiveCompare($1.surname_1) == ComparisonResult.orderedAscending }
        }else{
            People = People.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        }
        
    }

}
