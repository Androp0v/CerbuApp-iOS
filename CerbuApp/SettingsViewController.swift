//
//  SettingsViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 09/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet var lockLabel: UILabel!
    @IBOutlet var orderSwitch: UISwitch!
    @IBOutlet var lockImage: UIImageView!
    @IBOutlet var lockSwitch: UISwitch!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let surnameFirst = defaults.bool(forKey: "surnameFirst")
        let becaUnlocked = defaults.bool(forKey: "becaUnlocked")
        let showRooms = defaults.bool(forKey: "showRooms")
        
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lockTapped(tapGestureRecognizer:)))
        lockImage.isUserInteractionEnabled = true
        lockImage.addGestureRecognizer(tapGestureRecognizer)
        
        if becaUnlocked{
            lockImage.image = UIImage(systemName: "lock.open.fill")
            lockLabel.textColor = .label
            lockImage.tintColor = .label
            lockSwitch.isEnabled = true
            lockImage.removeGestureRecognizer(tapGestureRecognizer)
        }else{
            //Do nothing
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
