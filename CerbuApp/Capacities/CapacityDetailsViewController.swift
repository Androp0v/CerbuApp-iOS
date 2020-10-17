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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
