//
//  FilterTableViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 08/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    @IBAction func dismissViewController(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var soloAdjuntosSwitch: UISwitch!
    @IBOutlet var soloFavoritosSwitch: UISwitch!
    @IBOutlet var maleSwitch: UISwitch!
    @IBOutlet var femaleSwitch: UISwitch!
    @IBOutlet var nbotherSwitch: UISwitch!
    @IBOutlet var oneSwitch: UISwitch!
    @IBOutlet var twoSwitch: UISwitch!
    @IBOutlet var threeSwitch: UISwitch!
    @IBOutlet var fourSwitch: UISwitch!
    
    @IBAction func soloAdjuntosSwitchChange(_ sender: Any) {
        if soloAdjuntosSwitch.isOn{
            defaults.set(true, forKey: "soloAdjuntos")
        }else{
            defaults.set(false, forKey: "soloAdjuntos")
        }
    }
    @IBAction func soloFavoritosSwitchChange(_ sender: Any) {
        if soloFavoritosSwitch.isOn{
            defaults.set(true, forKey: "soloFavoritos")
        }else{
            defaults.set(false, forKey: "soloFavoritos")
        }
    }
    @IBAction func maleSwitchChange(_ sender: Any) {
        if maleSwitch.isOn{
            defaults.set(true, forKey: "male")
        }else{
            defaults.set(false, forKey: "male")
        }
    }
    @IBAction func femaleSwitchChange(_ sender: Any) {
        if femaleSwitch.isOn{
            defaults.set(true, forKey: "female")
        }else{
            defaults.set(false, forKey: "female")
        }
    }
    @IBAction func nbothersSwitchChange(_ sender: Any) {
        if nbotherSwitch.isOn{
            defaults.set(true, forKey: "nbothers")
        }else{
            defaults.set(false, forKey: "nbothers")
        }
    }
    @IBAction func oneSwitchChange(_ sender: Any) {
        if oneSwitch.isOn{
            defaults.set(true, forKey: "100s")
        }else{
            defaults.set(false, forKey: "100s")
        }
    }
    @IBAction func twoSwitchChange(_ sender: Any) {
        if twoSwitch.isOn{
            defaults.set(true, forKey: "200s")
        }else{
            defaults.set(false, forKey: "200s")
        }
    }
    @IBAction func threeSwitchChange(_ sender: Any) {
        if threeSwitch.isOn{
            defaults.set(true, forKey: "300s")
        }else{
            defaults.set(false, forKey: "300s")
        }
    }
    @IBAction func fourSwitchChange(_ sender: Any) {
        if fourSwitch.isOn{
            defaults.set(true, forKey: "400s")
        }else{
            defaults.set(false, forKey: "400s")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "soloAdjuntos"){
            soloAdjuntosSwitch.isOn = true
        }else{
            soloAdjuntosSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "soloFavoritos"){
            soloFavoritosSwitch.isOn = true
        }else{
            soloFavoritosSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "male"){
            maleSwitch.isOn = true
        }else{
            maleSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "female"){
            femaleSwitch.isOn = true
        }else{
            femaleSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "nbothers"){
            nbotherSwitch.isOn = true
        }else{
            nbotherSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "100s"){
            oneSwitch.isOn = true
        }else{
            oneSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "200s"){
            twoSwitch.isOn = true
        }else{
            twoSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "300s"){
            threeSwitch.isOn = true
        }else{
            threeSwitch.isOn = false
        }
        
        if defaults.bool(forKey: "400s"){
            fourSwitch.isOn = true
        }else{
            fourSwitch.isOn = false
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 4
        default:
            return 0
        }
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
