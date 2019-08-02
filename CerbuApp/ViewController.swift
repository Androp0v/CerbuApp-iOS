//
//  ViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet var orlaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orlaImageView.layer.cornerRadius = 30

    }

}
