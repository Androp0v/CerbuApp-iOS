//
//  ViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var orlaImageView: UIImageView!
    @IBOutlet var ContainerView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orlaImageView.layer.cornerRadius = 20.0
        ContainerView.layer.cornerRadius = 20.0
        ContainerView.layer.shadowColor = UIColor.init(named: "LighOnlyShadow")?.cgColor
        ContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        ContainerView.layer.shadowRadius = 12.0
        ContainerView.layer.shadowOpacity = 0.5
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0.0
        tap.cancelsTouchesInView = false
        tap.delegate = self
        ContainerView.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer){
        
        let touchLocation = gesture.location(in: ContainerView)
        
        //Only perform segue on releasing button
        if gesture.state == .ended {
            //Only perform segue if tap is released inside button area (and not outside)
            if ContainerView.bounds.contains(touchLocation) {
                //Perform segue
                self.performSegue(withIdentifier: "pushFromOrla", sender: self)
            }
        }
    }
}
