//
//  SettingsViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 09/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SQLite3

class SettingsViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet var lockLabel: UILabel!
    @IBOutlet var orderSwitch: UISwitch!
    @IBOutlet var lockImage: UIImageView!
    @IBOutlet var lockSwitch: UISwitch!
    @IBOutlet var lockImageNotifs: UIImageView!
    @IBOutlet var lockSwitchNotifs: UISwitch!
    @IBOutlet var lockSwitchNotifLabel: UILabel!
    
    @IBOutlet weak var footerLabel: UILabel!
    
    @IBAction func orderSwitchChanged(_ sender: Any) {
        if orderSwitch.isOn{
            defaults.set(false, forKey: "surnameFirst")
        }else{
            defaults.set(true, forKey: "surnameFirst")
        }
    }
    
    @IBAction func lockSwitchChanged(_ sender: Any) {
        if lockSwitch.isOn{
            defaults.set(true, forKey: "showRooms")
        }else{
            defaults.set(false, forKey: "showRooms")
        }
    }
    
    @IBAction func lockSwitchNotifsChanged(_ sender: Any) {
        if lockSwitchNotifs.isOn{
            defaults.set(true, forKey: "showNotifs")
        }else{
            defaults.set(false, forKey: "showNotifs")
        }
    }
    
    @objc func handleFooterTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "pushFromSettings", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let surnameFirst = defaults.bool(forKey: "surnameFirst")
        let becaUnlocked = defaults.bool(forKey: "becaUnlocked")
        let notifsUnlocked = defaults.bool(forKey: "notifsUnlocked")
        let showRooms = defaults.bool(forKey: "showRooms")
        let showNotifs = defaults.bool(forKey: "showNotifs")
        
        if surnameFirst{
            orderSwitch.isOn = false
        }else{
            orderSwitch.isOn = true
        }
        
        if showRooms{
            lockSwitch.isOn = true
        }else{
            lockSwitch.isOn = false
        }
        
        if showNotifs{
            lockSwitchNotifs.isOn = true
        }else{
            lockSwitchNotifs.isOn = false
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lockTapped(tapGestureRecognizer:)))
        lockImage.isUserInteractionEnabled = true
        lockImage.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerNotifs = UITapGestureRecognizer(target: self, action: #selector(lockTappedNotifs(tapGestureRecognizer:)))
        lockImageNotifs.isUserInteractionEnabled = true
        lockImageNotifs.addGestureRecognizer(tapGestureRecognizerNotifs)
        
        if becaUnlocked{
            lockImage.image = UIImage(systemName: "lock.open.fill")
            lockLabel.textColor = .label
            lockImage.tintColor = .label
            lockSwitch.isEnabled = true
            lockImage.removeGestureRecognizer(tapGestureRecognizer)
        }
        
        if notifsUnlocked{
            lockImageNotifs.image = UIImage(systemName: "lock.open.fill")
            lockSwitchNotifLabel.textColor = .label
            lockImageNotifs.tintColor = .label
            lockSwitchNotifs.isEnabled = true
            lockImageNotifs.removeGestureRecognizer(tapGestureRecognizerNotifs)
        }
        
        // Add link to bottom label
        let labelString = NSMutableAttributedString(string: "2020 © Raúl Montón Pinillos")
        labelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location:0,length:7))
        labelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: NSRange(location:7,length:20))
        footerLabel.attributedText = labelString
        
        // Handle taps in footer
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleFooterTap(_:)))
        footerLabel.addGestureRecognizer(tap)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    @objc func lockTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        var alertController:UIAlertController?

        alertController = UIAlertController(title: "Contraseña",
            message: "Introduce la contraseña para desbloquear la base de datos para adjuntos a la dirección",
            preferredStyle: .alert)
        
        alertController!.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter something"
        })
        
        alertController?.textFields?[0].isSecureTextEntry = true
        
        let action = UIAlertAction(title: "Submit",
                                   style: UIAlertAction.Style.default,
                                   handler: {[weak self]
                                   (paramAction:UIAlertAction!) in
            if let textFields = alertController?.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                if enteredText == "Tungsteno"{
                    self!.lockImage.image = UIImage(systemName: "lock.open.fill")
                    self!.lockLabel.textColor = .label
                    self!.lockImage.tintColor = .label
                    self!.lockSwitch.isEnabled = true
                    self!.defaults.set(true, forKey: "becaUnlocked")
                }
            }
        })
        
        alertController?.addAction(action)
        
        self.present(alertController!, animated: true, completion: nil)
        
    }
    
    @objc func lockTappedNotifs(tapGestureRecognizer: UITapGestureRecognizer)
    {
        var alertController:UIAlertController?

        alertController = UIAlertController(title: "Contraseña",
            message: "Introduce la contraseña para poder enviar avisos a todos los colegiales",
            preferredStyle: .alert)
        
        alertController!.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter something"
        })
        
        alertController?.textFields?[0].isSecureTextEntry = true
        
        let action = UIAlertAction(title: "Submit",
                                   style: UIAlertAction.Style.default,
                                   handler: {[weak self]
                                   (paramAction:UIAlertAction!) in
            if let textFields = alertController?.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                if enteredText == "Tungsteno"{
                    self!.lockImageNotifs.image = UIImage(systemName: "lock.open.fill")
                    self!.lockSwitchNotifLabel.textColor = .label
                    self!.lockImageNotifs.tintColor = .label
                    self!.lockSwitchNotifs.isEnabled = true
                    self!.defaults.set(true, forKey: "notifsUnlocked")
                }
            }
        })
        
        alertController?.addAction(action)
        
        self.present(alertController!, animated: true, completion: nil)
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if !isAuthorPresent() {
            addAuthor()
        }
        
        // Get the new view controller using segue.destination.
        if (segue.identifier == "pushFromSettings") {
            let authorViewController = (segue.destination as! DetailsViewController)
            let author = Person(id: 0, name: "Raúl", surname_1: "Montón", surname_2: "Pinillos", career: "Física", beca: "Asociación de Antiguos Colegiales (2019-2020)", room: "Ex-colegial", floor: 300, liked: false, gender: 0)
            authorViewController.detailedPerson = author
        }
        
    }
    
    func isAuthorPresent() -> Bool {
        
        let fileManager = FileManager.default
        let databaseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let finalDatabaseURL = databaseURL.first!.appendingPathComponent("database.db")
        var db: OpaquePointer?
        
        if sqlite3_open(finalDatabaseURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        let queryString = "SELECT * FROM colegiales WHERE names = 'Raúl' AND surnames_1 = 'Montón' AND surnames_2 = 'Pinillos' "
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            print("YES AUTHOR IS IN DATABASE WEE")
            return true
        } else {
            print("NO AUTHOR IS NOT IN DATABASE, SAD")
            return false
        }
        
    }
    
    func addAuthor() {
        
        let fileManager = FileManager.default
        let databaseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let finalDatabaseURL = databaseURL.first!.appendingPathComponent("database.db")
        var db: OpaquePointer?
        
        if sqlite3_open(finalDatabaseURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        
        let insertStatementString = "INSERT INTO colegiales (_id, names, surnames_1, surnames_2, careers, rooms, becas, likes, floors, promotions, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let _id: Int32 = 999
            let names: NSString = "Raúl"
            let surnames_1: NSString = "Montón"
            let surnames_2: NSString = "Pinillos"
            let careers: NSString = "Física"
            let rooms: NSString = "Ex-Colegial"
            let becas: NSString = "Asociación de Antiguos Colegiales (2019-2020)"
            let likes: Int32 = 0
            let floors: Int32 = 300
            let promotions: Int32 = 5
            let gender: Int32 = 0

            sqlite3_bind_int(insertStatement, 1, _id)
            sqlite3_bind_text(insertStatement, 2, names.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, surnames_1.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, surnames_2.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, careers.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, rooms.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, becas.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 8, likes)
            sqlite3_bind_int(insertStatement, 9, floors)
            sqlite3_bind_int(insertStatement, 10, promotions)
            sqlite3_bind_int(insertStatement, 11, gender)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
              print("\nSuccessfully inserted row.")
            } else {
              print("\nCould not insert row.")
            }
          } else {
            print("\nINSERT statement is not prepared.")
          }
          // 5
          sqlite3_finalize(insertStatement)
        
    }
    
}
