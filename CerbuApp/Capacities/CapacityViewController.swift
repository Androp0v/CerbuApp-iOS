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

    @IBOutlet weak var salaPolivalenteContainerView: UIView!
    @IBOutlet weak var salaPolivalenteProgressBar: UIView!
    @IBOutlet weak var salaPolivalenteDescription: UILabel!
    
    @IBOutlet weak var salaDeLecturaContainerView: UIView!
    @IBOutlet weak var salaDeLecturaProgressBar: UIView!
    @IBOutlet weak var salaDeLecturaDescription: UILabel!
    
    @IBOutlet weak var bibliotecaContainerView: UIView!
    @IBOutlet weak var bibliotecaProgressBar: UIView!
    @IBOutlet weak var bibliotecaDescription: UILabel!
    
    @IBOutlet weak var gimnasioContainerView: UIView!
    @IBOutlet weak var gimnasioProgressBar: UIView!
    @IBOutlet weak var gimnasioDescription: UILabel!
    
    
    // Location views
    
    @IBOutlet weak var salaPolivalenteLocationView: UIView!
    @IBOutlet weak var salaDeLecturaCurrentLocationView: UIView!
    @IBOutlet weak var bibliotecaCurrentLocationView: UIView!
    @IBOutlet weak var gimnasioCurrentLocationView: UIView!
    
    @IBAction func buttonCheckout(_ sender: Any) {
        // Hide CurrentLocationViews
        salaPolivalenteLocationView.isHidden = true
        salaDeLecturaCurrentLocationView.isHidden = true
        bibliotecaCurrentLocationView.isHidden = true
        gimnasioCurrentLocationView.isHidden = true
        
        // Remove value from database
        let userID = defaults.object(forKey: "userID") as! String
        Database.database().reference().child("Capacities/Check-ins").child(userID).removeValue()
    }
    
    
    let defaults = UserDefaults.standard
    
    var salaPolivalenteFractionNumber: Float = -1.0
    var salaDeLecturaFractionNumber: Float = -1.0
    var bibliotecaFractionNumber: Float = -1.0
    var gimnasioFractionNumber: Float = -1.0
    
    var salaPolivalenteFractionNumberOld: Float = 0.0
    var salaDeLecturaFractionNumberOld: Float = 0.0
    var bibliotecaFractionNumberOld: Float = 0.0
    var gimnasioFractionNumberOld: Float = 0.0
    
    var databaseReference: DatabaseReference!
    var databaseReferenceUser: DatabaseReference!
    
    var salaPolivalenteConstraint = NSLayoutConstraint.init()
    var salaDeLecturaConstraint = NSLayoutConstraint.init()
    var bibliotecaConstraint = NSLayoutConstraint.init()
    var gimnasioConstraint = NSLayoutConstraint.init()
    
    var salaPolivalenteMax: Int = 0
    var salaDeLecturaMax: Int = 0
    var bibliotecaMax: Int = 0
    var gimnasioMax: Int = 0
    
    private func getProgressBarColor(fractionNumber: Float) -> UIColor{
        
        if fractionNumber >= 0 && fractionNumber < 0.3 {
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
    
    private func getDescriptionString(fractionNumber: Float) -> String{
        if fractionNumber >= 0 && fractionNumber < 0.3 {
            return "Vacío o casi vacío"
        }else if fractionNumber >= 0.3 && fractionNumber < 0.6{
            return "Ocupación moderada o baja"
        }else if fractionNumber >= 0.6 && fractionNumber < 0.8{
            return "Ocupación moderada o alta"
        }else if fractionNumber >= 0.8{
            return "Lleno o casi lleno"
        }else{
            return "Ocupación desconocida"
        }
    }
    
    private func animateProgressBars(){
        
        // Deactivate constraints
        NSLayoutConstraint.deactivate([
            salaPolivalenteConstraint,
            salaDeLecturaConstraint,
            bibliotecaConstraint,
        ])
        
        // Create the constraints for the progressBars
        salaPolivalenteConstraint = salaPolivalenteProgressBar.widthAnchor.constraint(equalTo: salaPolivalenteContainerView.widthAnchor, multiplier: CGFloat(max(0,salaPolivalenteFractionNumber)))
        salaDeLecturaConstraint = salaDeLecturaProgressBar.widthAnchor.constraint(equalTo: salaDeLecturaContainerView.widthAnchor, multiplier: CGFloat(max(0,salaDeLecturaFractionNumber)))
        bibliotecaConstraint = bibliotecaProgressBar.widthAnchor.constraint(equalTo: bibliotecaContainerView.widthAnchor, multiplier: CGFloat(max(0,bibliotecaFractionNumber)))
        gimnasioConstraint = gimnasioProgressBar.widthAnchor.constraint(equalTo: gimnasioContainerView.widthAnchor, multiplier: CGFloat(max(0,gimnasioFractionNumber)))
        
        // Activate constraint(s)
        NSLayoutConstraint.activate([
            salaPolivalenteConstraint,
            salaDeLecturaConstraint,
            bibliotecaConstraint,
            gimnasioConstraint,
        ])
        
        // Set progressbar colors
        salaPolivalenteProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: salaPolivalenteFractionNumber)
        salaDeLecturaProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: salaDeLecturaFractionNumber)
        bibliotecaProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: bibliotecaFractionNumber)
        gimnasioProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: gimnasioFractionNumber)
        
        // Set label descriptions
        salaPolivalenteDescription.text = getDescriptionString(fractionNumber: salaPolivalenteFractionNumber)
        salaDeLecturaDescription.text = getDescriptionString(fractionNumber: salaDeLecturaFractionNumber)
        bibliotecaDescription.text = getDescriptionString(fractionNumber: bibliotecaFractionNumber)
        gimnasioDescription.text = getDescriptionString(fractionNumber: gimnasioFractionNumber)
        
        // Animate initial progress bar positions
        UIView.animate(withDuration: Double(abs(salaPolivalenteFractionNumber-salaPolivalenteFractionNumberOld)), animations: {
            self.salaPolivalenteContainerView?.layoutIfNeeded()
            })
        UIView.animate(withDuration: Double(abs(salaDeLecturaFractionNumber-salaDeLecturaFractionNumberOld)), animations: {
            self.salaDeLecturaContainerView?.layoutIfNeeded()
            })
        UIView.animate(withDuration: Double(abs(bibliotecaFractionNumber-bibliotecaFractionNumberOld)), animations: {
            self.bibliotecaContainerView?.layoutIfNeeded()
            })
        UIView.animate(withDuration: Double(abs(gimnasioFractionNumber-gimnasioFractionNumberOld)), animations: {
            self.gimnasioContainerView?.layoutIfNeeded()
            })
        
        // Update "old" fraction numbers
        salaPolivalenteFractionNumberOld = salaPolivalenteFractionNumber
        salaDeLecturaFractionNumberOld = salaDeLecturaFractionNumber
        bibliotecaFractionNumberOld = bibliotecaFractionNumber
        gimnasioFractionNumberOld = gimnasioFractionNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Firebase Realtime Database reference
        databaseReference = Database.database().reference().child("Capacities/Count")
        databaseReferenceUser = Database.database().reference().child("Capacities/Check-ins").child(defaults.object(forKey: "userID") as! String)
        
        // Observe for changes in the user location (if any)
        databaseReferenceUser.observe(.value, with: {snapshot in
            if !(snapshot.value is NSNull){
                let value = snapshot.value as! [String: Any]
                if value["Room"] as! String == "SalaPolivalente"{
                    self.salaPolivalenteLocationView.isHidden = false
                }else{
                    self.salaPolivalenteLocationView.isHidden = true
                }
                
                if value["Room"] as! String == "SalaDeLectura"{
                    self.salaDeLecturaCurrentLocationView.isHidden = false
                }else{
                    self.salaDeLecturaCurrentLocationView.isHidden = true
                }
                
                if value["Room"] as! String == "Biblioteca"{
                    self.bibliotecaCurrentLocationView.isHidden = false
                }else{
                    self.bibliotecaCurrentLocationView.isHidden = true
                }
                
                if value["Room"] as! String == "Gimnasio"{
                    self.gimnasioCurrentLocationView.isHidden = false
                }else{
                    self.gimnasioCurrentLocationView.isHidden = true
                }
            }
        })
        
        // Observe for changes in the counts database
        databaseReference.queryLimited(toFirst: 10).observe(.value, with: { snapshot in
                                                                
            let value = snapshot.value as! [String: Any]
            
            let sortedKeys = Array(value.keys).sorted(by: >)
                        
            for (room) in sortedKeys{
                if room == "SalaPolivalente" {
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.salaPolivalenteFractionNumber = -1
                    }else{
                        self.salaPolivalenteFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                        self.salaPolivalenteMax = maxCapacity
                    }
                } else if room == "SalaDeLectura" {
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.salaDeLecturaFractionNumber = -1
                    }else{
                        self.salaDeLecturaFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                        self.salaDeLecturaMax = maxCapacity
                    }
                } else if room == "Biblioteca"{
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.bibliotecaFractionNumber = -1
                    }else{
                        self.bibliotecaFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                        self.bibliotecaMax = maxCapacity
                    }
                } else if room == "Gimnasio" {
                    let currentCapacity = (value[room] as! [String: Int])["Current"] ?? 0
                    let maxCapacity = (value[room] as! [String: Int])["Max"] ?? 0
                    if maxCapacity == -1{
                        self.gimnasioFractionNumber = -1
                    }else{
                        self.gimnasioFractionNumber = Float(currentCapacity)/Float(maxCapacity)
                        self.gimnasioMax = maxCapacity
                    }
                }
            }
            
            // Animate progress bars after database changes
            self.animateProgressBars()
            
        })
        
        // Fix weird layout constraints mistakenly being animated
        self.salaPolivalenteContainerView?.layoutIfNeeded()
        self.salaDeLecturaContainerView?.layoutIfNeeded()
        self.bibliotecaContainerView?.layoutIfNeeded()
        self.gimnasioContainerView?.layoutIfNeeded()
        
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
