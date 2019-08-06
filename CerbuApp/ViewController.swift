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

class ViewController: UIViewController {

    @IBOutlet var orlaImageView: UIImageView!
    @IBOutlet var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orlaImageView.layer.cornerRadius = 20.0
        ContainerView.layer.cornerRadius = 20.0
        ContainerView.layer.shadowColor = UIColor.init(named: "LighOnlyShadow")?.cgColor
        ContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        ContainerView.layer.shadowRadius = 12.0
        ContainerView.layer.shadowOpacity = 0.7
    }

}
