//
//  BoletinViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 12/08/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SwiftUI
import WebKit

/// Wrapper to present the Storyboard view inside a SwiftUI view
struct BoletinView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BoletinView")
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

class BoletinViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var BoletinHeader: UIImageView!
    @IBOutlet var boletinContentWebView: WKWebView!
    @IBOutlet var spinningWheel: UIActivityIndicatorView!
        
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
        
        boletinContentWebView.navigationDelegate = self
        let urlString = "https://drive.google.com/uc?id=1mqVm0maDENVejJuqvybHHOEgotN7wMNU"
        let string = "<html><body marginwidth=\"0\" marginheight=\"0\" style=\"background-color: transparent\"><embed width=\"100%\" name=\"plugin\" src=\"\(urlString)\" type=\"application/pdf\"></body></html>"
        boletinContentWebView.loadHTMLString(string, baseURL: nil)
        boletinContentWebView.backgroundColor = UIColor.clear
        boletinContentWebView.alpha = 0.0
        boletinContentWebView.isOpaque = true
        boletinContentWebView.layer.zPosition = 1
        spinningWheel.stopAnimating()
        spinningWheel.layer.zPosition = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // in half a second...
            self.spinningWheel.startAnimating()
            self.spinningWheel.layer.zPosition = 0
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinningWheel.stopAnimating()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.boletinContentWebView.alpha = 1.0
        }, completion: nil)
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
