//
//  MenuViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 12/08/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import WebKit

class MenuViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://cerbuna.unizar.es/sites/cerbuna.unizar.es/files/users/temporales/menu.pdf")!))
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
