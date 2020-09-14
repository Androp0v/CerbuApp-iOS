//
//  CapacityViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 13/9/20.
//  Copyright © 2020 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import Firebase

class CapacityViewController: UIViewController {

    @IBOutlet weak var comedorContainerView: UIView!
    @IBOutlet weak var comedorProgressBar: UIView!
    
    @IBOutlet weak var salaDeLecturaContainerView: UIView!
    @IBOutlet weak var salaDeLecturaProgressBar: UIView!
    
    @IBOutlet weak var bibliotecaContainerView: UIView!
    @IBOutlet weak var bibliotecaProgressBar: UIView!
    
    let defaults = UserDefaults.standard
    
    var comedorFractionNumber: Float = -1.0
    var salaDeLecturaFractionNumber: Float = -1.0
    var bibliotecaFractionNumber: Float = -1.0
    
    var databaseReference: DatabaseReference!
    
    var roomName = [String]()
    var roomCapacityCurrent = [Int]()
    var roomCapacityMax = [Int]()
    
    private func getProgressBarColor(fractionNumber: Float) -> UIColor{
        
        if fractionNumber < 0.3 {
            return UIColor.systemGreen
        }else if fractionNumber >= 0.3 && fractionNumber < 0.6{
            return UIColor.systemYellow
        }else if fractionNumber >= 0.6 && fractionNumber < 0.8{
            return UIColor.systemOrange
        }else if fractionNumber >= 0.8{
            return UIColor.systemRed
        }else{
            return UIColor.systemGray
        }
    }
    
    private func animateProgressBars(){
        
        // Create the constraints for the progressBars
        let comedorConstraint = comedorProgressBar.widthAnchor.constraint(equalTo: comedorContainerView.widthAnchor, multiplier: CGFloat(max(0,comedorFractionNumber)))
        let salaDeLecturaConstraint = salaDeLecturaProgressBar.widthAnchor.constraint(equalTo: salaDeLecturaContainerView.widthAnchor, multiplier: CGFloat(max(0,salaDeLecturaFractionNumber)))
        let bibliotecaConstraint = bibliotecaProgressBar.widthAnchor.constraint(equalTo: bibliotecaContainerView.widthAnchor, multiplier: CGFloat(max(0,bibliotecaFractionNumber)))
        
        // Activate constraint(s)
        NSLayoutConstraint.activate([
            comedorConstraint,
            salaDeLecturaConstraint,
            bibliotecaConstraint,
        ])
        
        // Set initial progressbar colors
        comedorProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: comedorFractionNumber)
        salaDeLecturaProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: salaDeLecturaFractionNumber)
        bibliotecaProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: bibliotecaFractionNumber)
        
        // Animate initial progress bar positions
        UIView.animate(withDuration: Double(max(0,comedorFractionNumber)), animations: {
            self.comedorContainerView?.layoutIfNeeded()
            })
        UIView.animate(withDuration: Double(max(0,salaDeLecturaFractionNumber)), animations: {
            self.salaDeLecturaContainerView?.layoutIfNeeded()
            })
        UIView.animate(withDuration: Double(max(0,bibliotecaFractionNumber)), animations: {
            self.bibliotecaContainerView?.layoutIfNeeded()
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Firebase Realtime Database reference
        databaseReference = Database.database().reference().child("Capacities/Count")
        
        // Observe for changes in the database
        databaseReference.queryLimited(toFirst: 10).observe(.value, with: { snapshot in
                                                                
            let value = snapshot.value as! [String: Any]
            
            self.roomName = []
            self.roomCapacityCurrent = []
            self.roomCapacityMax = []
            
            let sortedKeys = Array(value.keys).sorted(by: >)
                        
            for (room) in sortedKeys{
                if room == "Comedor"{
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.comedorFractionNumber = -1
                    }else{
                        self.comedorFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                    }
                }else if room == "SalaDeLectura"{
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.salaDeLecturaFractionNumber = -1
                    }else{
                        self.salaDeLecturaFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                    }
                }else if room == "Biblioteca"{
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.bibliotecaFractionNumber = -1
                    }else{
                        self.bibliotecaFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                    }
                }
            }
            
            // Animate progress bars after database changes
            self.animateProgressBars()
            
        })
        
        // Fix weird layout constraints mistakenly being animated
        self.comedorContainerView?.layoutIfNeeded()
        self.salaDeLecturaContainerView?.layoutIfNeeded()
        self.bibliotecaContainerView?.layoutIfNeeded()
        
        // Animate progressbars with initial values
        animateProgressBars()
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
