//
//  ListViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SQLite3

class TableViewController: UITableViewController {
    
    var People = [Person]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSamplePeople()
        
        
        var db: OpaquePointer?
        let databaseURL = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("database.db")
        
        if sqlite3_open(databaseURL?.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return People.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadSamplePeople() {
        let photo1 = UIImage(named: "nohres")!
        
        let person1 = Person(name: "Adrián", surname_1: "Arribas", surname_2: "Vinuesa", career: "Biotecnología", beca: "", room: "409", floor: 400, iconPhoto: photo1)!
        
        People += [person1]
        
    }
    
    private func loadPeopleFromDatabase(){
        
    }

}
