//
//  MagazineController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 20/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import PDFKit
import SwiftUI

/// Wrapper to present the Storyboard view inside a SwiftUI view
struct MagazineView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MagazineView")
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

class MagazineController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the PDF view
        let filePath = Bundle.main.url(forResource: "PatioInterior", withExtension: "pdf")!
                
        let pdfDocument = PDFDocument(url: filePath)
        
        self.edgesForExtendedLayout = []
        
        // Add view to ViewController
        
        let pdfView = PDFView(frame: view.bounds)

        view.addSubview(pdfView)
                
        pdfView.document = pdfDocument
        
        pdfView.autoScales = true
    }
    
}
