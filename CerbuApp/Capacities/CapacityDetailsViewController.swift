//
//  CapacityDetailsViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 18/9/20.
//  Copyright © 2020 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class CapacityDetailsViewController: UIViewController {
    
    var fractionNumber: Float = 0
    var maxCapacity: Int = 0

    @IBOutlet weak var progressbarContainer: UIView!
    @IBOutlet weak var progressbarBar: UIView!
    
    @IBOutlet weak var sheetTitle: UILabel!
    @IBOutlet weak var sheetDescription: UILabel!
    
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
    
    private func animateProgressBar(){
        
        // Create the constraints for the progressBars
        let progressbarConstraint = progressbarBar.widthAnchor.constraint(equalTo: progressbarContainer.widthAnchor, multiplier: CGFloat(max(0,fractionNumber)))
        
        // Activate constraint(s)
        NSLayoutConstraint.activate([
            progressbarConstraint
        ])
        
        // Set progressbar colors
        progressbarBar.backgroundColor = getProgressBarColor(fractionNumber: fractionNumber)
        
        // Animate initial progress bar positions
        UIView.animate(withDuration: Double(abs(fractionNumber)), animations: {
            self.progressbarContainer?.layoutIfNeeded()
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sheetTitle.text = String( Int(round(fractionNumber * Float(maxCapacity))) ) + " de " + String(maxCapacity) + " personas"
        
        animateProgressBar()
        
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
