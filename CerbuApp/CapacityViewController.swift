//
//  CapacityViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 13/9/20.
//  Copyright © 2020 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class CapacityViewController: UIViewController {

    @IBOutlet weak var comedorContainerView: UIView!
    @IBOutlet weak var comedorProgressBar: UIView!
    
    @IBOutlet weak var salaDeLecturaContainerView: UIView!
    @IBOutlet weak var salaDeLecturaProgressBar: UIView!
    
    @IBOutlet weak var bibliotecaContainerView: UIView!
    @IBOutlet weak var bibliotecaProgressBar: UIView!
    
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.comedorContainerView?.layoutIfNeeded()
        self.salaDeLecturaContainerView?.layoutIfNeeded()
        self.bibliotecaContainerView?.layoutIfNeeded()
        
        // Create the constraints for the progressBars
        let comedorConstraint = comedorProgressBar.widthAnchor.constraint(equalTo: comedorContainerView.widthAnchor, multiplier: 0.8)
        let salaDeLecturaConstraint = salaDeLecturaProgressBar.widthAnchor.constraint(equalTo: salaDeLecturaContainerView.widthAnchor, multiplier: 0.25)
        let bibliotecaConstraint = bibliotecaProgressBar.widthAnchor.constraint(equalTo: bibliotecaContainerView.widthAnchor, multiplier: 0.6)
        
        // Activate constraint(s)
        NSLayoutConstraint.activate([
            comedorConstraint,
            salaDeLecturaConstraint,
            bibliotecaConstraint,
        ])
        
        // Animate progress bars
        UIView.animate(withDuration: 0.8, animations: {
            self.comedorContainerView?.layoutIfNeeded()
            self.comedorProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: 0.8)
            })
        UIView.animate(withDuration: 0.25, animations: {
            self.salaDeLecturaContainerView?.layoutIfNeeded()
            self.salaDeLecturaProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: 0.25)
            })
        UIView.animate(withDuration: 0.6, animations: {
            self.bibliotecaContainerView?.layoutIfNeeded()
            self.bibliotecaProgressBar.backgroundColor = self.getProgressBarColor(fractionNumber: 0.6)
            })
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
