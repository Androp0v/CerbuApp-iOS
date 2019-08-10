//
//  DetailsViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 03/08/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    func cleanString(rawString: String) -> String{
        var cleanString = rawString
        cleanString = cleanString.lowercased()
        
        cleanString = cleanString.replacingOccurrences(of: " ", with: "")
        cleanString = cleanString.replacingOccurrences(of: "á", with: "a")
        cleanString = cleanString.replacingOccurrences(of: "é", with: "e")
        cleanString = cleanString.replacingOccurrences(of: "í", with: "i")
        cleanString = cleanString.replacingOccurrences(of: "ó", with: "o")
        cleanString = cleanString.replacingOccurrences(of: "ú", with: "u")
        cleanString = cleanString.replacingOccurrences(of: "ü", with: "u")
        return cleanString
    }
    
    var detailedPerson: Person?
    
    @IBOutlet var hresPhoto: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var careerLabel: UILabel!
    @IBOutlet var becaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Additional setup after loading the view.
        
        let nameLabelText: String = (detailedPerson?.name ?? "") + " " + (detailedPerson?.surname_1 ?? "")
        nameLabel.text = nameLabelText + " " + (detailedPerson?.surname_2 ?? "")
        
        if detailedPerson?.beca.isEmpty ?? true {
            careerLabel.text = detailedPerson?.career
            becaImageView = nil
        }else{
            careerLabel.text = (detailedPerson?.career ?? "") + " | " + (detailedPerson?.beca ?? "")
            becaImageView.image = UIImage.init(named: "becario")
        }
        
        hresPhoto.image = UIImage(named: (cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? "")))) ?? UIImage(named: "nohres")
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
