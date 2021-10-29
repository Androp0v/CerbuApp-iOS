//
//  NotificationsTableViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 14/10/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import Firebase
import UIKit
import SwiftUI

/// Wrapper to present the Storyboard view inside a SwiftUI view
struct NotificationsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NotificationsView")
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

class NotificationsTableViewController: UITableViewController {
    
    @IBOutlet var addNotification: UIBarButtonItem!
    
    var ref: DatabaseReference!
    var titleList = [String]()
    var messageList = [String]()
    var timestampList = [String]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child("Notifications")
        titleList = []
        messageList = []
        
        let showNotifs = defaults.bool(forKey: "showNotifs")
        
        if !showNotifs {
            addNotification.isEnabled = false
            addNotification.tintColor = UIColor.clear
        }
        
        self.tableView.allowsSelection = false
        
        ref.queryLimited(toLast: 15).queryOrdered(byChild: "Timestamp").observe(.value, with: { snapshot in
                                                                
            let value = snapshot.value as! [String: Any]
            
            self.titleList = []
            self.messageList = []
            
            let sortedKeys = Array(value.keys).sorted(by: >)
            
            for (notification) in sortedKeys{
                self.titleList.append((value[notification] as! [String: String])["Title"] ?? "" )
                self.messageList.append((value[notification] as! [String: String])["Message"] ?? "" )
            }
            
            self.tableView.reloadData()
                                                                
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.titleList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as? NotificationCell  else {
            fatalError("The dequeued cell is not an instance of NotificationCell.")
        }
        
        cell.title.text = titleList[indexPath.row]
        cell.message.text = messageList[indexPath.row]

        return cell
    }
    

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