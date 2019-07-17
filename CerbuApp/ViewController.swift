//
//  ViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var orlaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orlaImageView.clipsToBounds = true
        orlaImageView.layer.cornerRadius = 30
    }


}

