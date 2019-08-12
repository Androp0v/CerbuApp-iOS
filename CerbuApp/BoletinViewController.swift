//
//  BoletinViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 12/08/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class BoletinViewController: UIViewController {

    @IBOutlet var BoletinHeader: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
        
        BoletinHeader.animationImages = [UIImage]()
        
        for i in 0...48{
            if i % 2 == 0{
                BoletinHeader.animationImages?.append(UIImage.init(named: "boletin_0" + String(i))!)
            }
        }
        
        BoletinHeader.animationDuration = 1
        BoletinHeader.animationRepeatCount = 1
        BoletinHeader.startAnimating()
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
