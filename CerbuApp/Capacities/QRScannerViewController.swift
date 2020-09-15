//
//  QRScannerViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 14/9/20.
//  Copyright © 2020 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import Firebase

class QRScannerViewController: UIViewController, QRScannerViewDelegate {
    @IBOutlet weak var QRScannerView: QRScannerView!
    @IBOutlet weak var errorOverlay: UIView!
    
    let defaults = UserDefaults.standard
    
    var databaseReference: DatabaseReference!
    
    private func blurErrorOverlayBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = errorOverlay.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        errorOverlay.addSubview(blurEffectView)
        errorOverlay.sendSubviewToBack(blurEffectView)
    }
    
    // Function to close QR Scanner when an error is encountered
    private func errorAndExitQRScanner(){
        errorOverlay.isHidden = false
        blurErrorOverlayBackground()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateCheckIn(QRString: String){
        
        let userID = defaults.object(forKey: "userID") as! String
        let epoch = NSDate().timeIntervalSince1970
        
        databaseReference.child(userID).observeSingleEvent(of: .value, with: { (userCheckIn) in
            if userCheckIn.exists(){
                // User already checked-in
                print("User already checked-in")
                self.databaseReference.child(userID).setValue([
                                                                "Room": QRString,
                                                                "Time": epoch
                ])
            }else{
                // User hadn't checked-in
                print("User hadn't checked-in")
                self.databaseReference.child(userID).setValue([
                                                                "Room": QRString,
                                                                "Time": epoch
                ])
            }
        })
    }
    
    // QRScannerView delegate protocol implementation
    
    func qrScanningDidFail() {
        errorAndExitQRScanner()
    }
    
    func qrScanningSucceededWithCode(code: String?) {
        if code == "Comedor"{
            dismiss(animated: true, completion: nil)
            updateCheckIn(QRString: "Comedor")
        }else if code == "Sala de Lectura"{
            dismiss(animated: true, completion: nil)
            updateCheckIn(QRString: "SalaDeLectura")
        }else if code == "Biblioteca"{
            dismiss(animated: true, completion: nil)
            updateCheckIn(QRString: "Biblioteca")
        }else{
            errorAndExitQRScanner()
        }
    }
    
    func qrScanningDidStop() {
        errorAndExitQRScanner()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        QRScannerView.delegate = self
        databaseReference = Database.database().reference().child("Capacities/Check-ins")
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
