//
//  ListViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SQLite3

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        return cleanString
    }
    
    @objc func onSegmentedControlHapticFeedback(sender: UISegmentedControl){
        print("This is called")
        let feedbackGenerator = UISelectionFeedbackGenerator.init()
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
    }
    
    var People = [Person]();
    var db: OpaquePointer?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: -0.5,left: 0,bottom: 0,right: 0)
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return People.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
        
        let person = People[indexPath.row]
        
        cell.nameLabel.text = person.name + " " + person.surname_1 + " " + person.surname_2
        cell.orlaImageView.image = person.iconPhoto
        cell.careerLabel.text = person.career
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        //let selectedPerson = People[indexPath.row]
        
        // Create an instance of DetailViewController and pass the variable
        //let destinationViewController = DetailsViewController()
        //destinationViewController.detailedPerson = selectedPerson
        
        self.performSegue(withIdentifier: "pushFromCell", sender: indexPath)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if (segue.identifier == "pushFromCell") {
            let controller = (segue.destination as! DetailsViewController)
            let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
            let selectedPerson = People[row]
            controller.detailedPerson = selectedPerson
        }
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: Private Methods
    
    private func loadPeopleFromDatabase(){
        
        let photo1 = UIImage(named: "nohres")!
        
        //this is our select query
        let queryString = "SELECT * FROM colegiales"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let surname_1 = String(cString: sqlite3_column_text(stmt, 2))
            let surname_2 = String(cString: sqlite3_column_text(stmt, 3))
            let career = String(cString: sqlite3_column_text(stmt, 4))
            let room = String(cString: sqlite3_column_text(stmt, 5))
            //let beca = String(cString: sqlite3_column_text(stmt, 6)) //TO-DO: Proper handling of nils
            let _like = sqlite3_column_int(stmt, 7)
            let floor = sqlite3_column_int(stmt, 8)
            let _promotion = sqlite3_column_int(stmt, 9)
            let iconPhoto = UIImage(named: (cleanString(rawString: name+surname_1))) ?? photo1
            
            //adding values to list
            People.append(Person(name: name, surname_1: surname_1, surname_2: surname_2, career: career, beca: "Test", room: room, floor: Int(floor), iconPhoto: iconPhoto)!)
        }
        
    }

}
