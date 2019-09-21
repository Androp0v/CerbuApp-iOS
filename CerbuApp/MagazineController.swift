//
//  MagazineController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 20/09/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import PDFKit

class MagazineController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        //self.delegate = (self as! UIPageViewControllerDelegate)
        let initialPage = 0

        // Do any additional setup after loading the view.
   
        let filePath = Bundle.main.url(forResource: "PatioInterior", withExtension: "pdf")!
                
        let pdfDocument = PDFDocument(url: filePath)
                
        let pageCount = pdfDocument!.pageCount - 1
        for index in 0...pageCount {
            let page: PDFPage = pdfDocument!.page(at: index)!
            let pdfView: PDFView = PDFView(frame: view.frame)
            
            pdfView.document = pdfDocument
            pdfView.go(to: page)
            
            pdfView.displayMode = .singlePage
            
            pdfView.backgroundColor = .systemBackground
            
            pdfView.autoresizesSubviews = true
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
            pdfView.autoScales = true
            pdfView.minScaleFactor = pdfView.scaleFactor
            pdfView.maxScaleFactor = pdfView.scaleFactorForSizeToFit
            let viewController = UIViewController()
            viewController.view = pdfView
            pages.append(viewController)
        }
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                //Pass
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
            
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                //Pass
            }
        }
        return nil
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
