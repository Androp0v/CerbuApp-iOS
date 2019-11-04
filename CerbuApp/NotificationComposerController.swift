//
//  NotificationComposerController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 14/10/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import Firebase

class NotificationComposerController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var messageTextView: UITextView!
    @IBAction func sendNotification(_ sender: Any) {
                
        guard let inputTitle = titleTextField.text, !inputTitle.isEmpty else {
            dismiss(animated: true, completion: nil)
            return
        }
        guard let inputMessage = messageTextView.text, !inputMessage.isEmpty else {
            dismiss(animated: true, completion: nil)
            return
        }
                
        let values = ["Title" : inputTitle, "Message" : inputMessage]
        
        ref = Database.database().reference().child("Notifications").childByAutoId()
        ref.setValue(values)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        titleTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        titleTextField.layer.borderWidth = 0.5;
        titleTextField.layer.cornerRadius = 5.0;
        titleTextField.backgroundColor = UIColor.secondarySystemBackground
        messageTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
        messageTextView.layer.borderWidth = 0.5;
        messageTextView.layer.cornerRadius = 5.0;
        messageTextView.backgroundColor = UIColor.secondarySystemBackground
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
