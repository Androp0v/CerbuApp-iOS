//
//  BarcodeViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 21/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SwiftUI

/// Wrapper to present the Storyboard view inside a SwiftUI view
struct BarcodeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BarcodeView")
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

class BarcodeViewController: UIViewController{

    @IBOutlet var passView: UIView!
    @IBOutlet var barcodeContainer: UIView!
    @IBOutlet var barcodeImage: UIImageView!
    var savedBrightness: CGFloat = 0.5
    var invited: Bool = false
    @IBOutlet var invitedButton: UIButton!
    
    @IBAction func invitedButtonPress(_ sender: Any) {
        if invited{
            invited = false
            invitedButton.setTitle("Mostrar código de invitados", for: .normal)
            barcodeImage.image = loadImageFromAppData()
        }else{
            invited = true
            invitedButton.setTitle("Mostrar código de colegial", for: .normal)
            barcodeImage.image = loadImageFromAppData()
        }
    }
    
    var imagePicker: ImagePicker!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        // Do any additional setup after loading the view.
        
        passView.layer.cornerRadius = 15
        passView.layer.shadowColor = UIColor.init(named: "LighOnlyShadow")?.cgColor
        passView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        passView.layer.shadowRadius = 12.0
        passView.layer.shadowOpacity = 0.3
        
        barcodeContainer.layer.cornerRadius = 5
        //barcodeImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        barcodeImage.image = loadImageFromAppData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadImage(tapGestureRecognizer:)))
        barcodeContainer.isUserInteractionEnabled = true
        barcodeContainer.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savedBrightness = UIScreen.main.brightness
        UIScreen.animateBrightness(to: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.animateBrightness(to: savedBrightness)
    }
    
    @objc func loadImage(tapGestureRecognizer: UITapGestureRecognizer){
        imagePicker.pickerController.sourceType = .photoLibrary
        imagePicker.presentationController?.present(imagePicker.pickerController, animated: true)
    }
    
    func loadImageFromAppData() -> UIImage {
        if !invited{
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
        }else{
            // declare image location
            let imageName = "barcodeInv" // your image name here
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
            let imageUrl: URL = URL(fileURLWithPath: imagePath)

            // check if the image is stored already
            if FileManager.default.fileExists(atPath: imagePath),
               let imageData: Data = try? Data(contentsOf: imageUrl),
               let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) {
              return image
            }
        }
        // image has not been created yet: create it, store it, return it
        return UIImage(named: "barcode")!
    }
    

}

extension UIScreen {
    private static let step: CGFloat = 0.05

    static func animateBrightness(to value: CGFloat) {
        guard abs(UIScreen.main.brightness - value) > step else { return }

        let delta = UIScreen.main.brightness > value ? -step : step

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            UIScreen.main.brightness += delta
            animateBrightness(to: value)
        }
    }
}

extension BarcodeViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.barcodeImage.image = image
        
        if !invited{
            //Store the image:
            let imageName = "barcode" // your image name here
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
            let imageUrl: URL = URL(fileURLWithPath: imagePath)
            
            let newImage: UIImage = self.barcodeImage.image ?? UIImage(named: "barcode")!
            try? newImage.pngData()?.write(to: imageUrl)
        }else{
            //Store the image:
            let imageName = "barcodeInv" // your image name here
            let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
            let imageUrl: URL = URL(fileURLWithPath: imagePath)
            
            let newImage: UIImage = self.barcodeImage.image ?? UIImage(named: "barcode")!
            try? newImage.pngData()?.write(to: imageUrl)
        }
    }
}
