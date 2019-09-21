//
//  BarcodeViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 21/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit


class BarcodeViewController: UIViewController{

    @IBOutlet var passView: UIView!
    @IBOutlet var barcodeContainer: UIView!
    @IBOutlet var barcodeImage: UIImageView!
    
    var imagePicker: ImagePicker!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        // Do any additional setup after loading the view.
        
        passView.layer.cornerRadius = 15
        passView.layer.shadowColor = UIColor.init(named: "LighOnlyShadow")?.cgColor
        passView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        passView.layer.shadowRadius = 12.0
        passView.layer.shadowOpacity = 0.2
        
        barcodeContainer.layer.cornerRadius = 5
        //barcodeImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        barcodeImage.image = loadImageFromAppData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadImage(tapGestureRecognizer:)))
        barcodeContainer.isUserInteractionEnabled = true
        barcodeContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func loadImage(tapGestureRecognizer: UITapGestureRecognizer){
        imagePicker.pickerController.sourceType = .photoLibrary
        imagePicker.presentationController?.present(imagePicker.pickerController, animated: true)
    }
    
    func loadImageFromAppData() -> UIImage {
      // declare image location
      let imageName = "barcode" // your image name here
      let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
      let imageUrl: URL = URL(fileURLWithPath: imagePath)

      // check if the image is stored already
      if FileManager.default.fileExists(atPath: imagePath),
         let imageData: Data = try? Data(contentsOf: imageUrl),
         let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) {
        return image
      }

      // image has not been created yet: create it, store it, return it
      return UIImage()
    }
    

}

extension BarcodeViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.barcodeImage.image = image
        
        //Store the image:
        let imageName = "barcode" // your image name here
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        let newImage: UIImage = self.barcodeImage.image ?? UIImage(named: "barcode")!
        try? newImage.pngData()?.write(to: imageUrl)
    }
}
