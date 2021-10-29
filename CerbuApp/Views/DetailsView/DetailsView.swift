//
//  DetailsViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 03/08/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit
import SQLite3
import SwiftUI

// MARK: - ViewHostingController

/// Wrapper to present DetailsView inside a UIKit context
class DetailsViewHostingController: UIHostingController<DetailsView> {

    var detailedPerson: Person
    var personIndex: Int

    init(person: Person, index: Int) {
        detailedPerson = person
        personIndex = index
        super.init(rootView: DetailsView(detailedPerson: person, personIndex: index))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}

// MARK: - View
struct DetailsView: View {
    @State var detailedPerson: Person
    @State var personIndex: Int

    var body: some View {
        if detailedPerson.isAuthor() {
            ZStack {
                Color(UIColor(displayP3Red: 9/255, green: 10/255, blue: 12/255, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                DetailsViewContent(detailedPerson: detailedPerson, pageIndex: personIndex)
                    .edgesIgnoringSafeArea(.bottom)
                    .customNavigationBarColor(color: .clear)
            }
        } else {
            ZStack {
                Color(UIColor(named: "MainAppColor")!)
                    .edgesIgnoringSafeArea(.all)
                DetailsViewContent(detailedPerson: detailedPerson, pageIndex: personIndex)
                    .edgesIgnoringSafeArea(.bottom)
                    .customNavigationBarColor(color: .clear)
            }
        }
    }
}

// MARK: - Content view
/// Wrapper to present the view  inside a SwiftUI view
struct DetailsViewContent: UIViewControllerRepresentable {

    @State var detailedPerson: Person?
    @State var pageIndex: Int?

    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailedController.detailedPerson = detailedPerson
        return detailedController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

// MARK: - UIViewController

class DetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
        cleanString = cleanString.replacingOccurrences(of: "ñ", with: "n")
        cleanString = cleanString.replacingOccurrences(of: "ç", with: "c")
        cleanString = cleanString.replacingOccurrences(of: "-", with: "")
        return cleanString
    }
    
    var detailedPerson: Person?
    let defaults = UserDefaults.standard
    var originalImageCenter:CGPoint?
    var isZooming = false

    @IBOutlet var hresPhoto: UIImageView!
    @IBOutlet var likedImageView: UIImageView!
    @IBOutlet var hresPhotoBackground: UIView!

    @IBOutlet weak var detailsFooterContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.layer.zPosition = -1;
        
        hresPhotoBackground.backgroundColor = .systemBackground

        // Setup SwiftUI footer
        if let detailedPerson = detailedPerson {
            let swiftUIView = DetailsFooterView(model: DetailsFooterViewModel(person: detailedPerson),
                                                container: self)
            let hostingController = UIHostingController(rootView: swiftUIView)
            addChild(hostingController)
            detailsFooterContainer.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                hostingController.view.topAnchor.constraint(equalTo: detailsFooterContainer.topAnchor),
                hostingController.view.leftAnchor.constraint(equalTo: detailsFooterContainer.leftAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: detailsFooterContainer.bottomAnchor),
                hostingController.view.rightAnchor.constraint(equalTo: detailsFooterContainer.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            hostingController.didMove(toParent: self)
        }

        // Like button
        
        if detailedPerson?.liked ?? false{
            likedImageView.image = UIImage.init(named: "HotIcon")
        }else{
            likedImageView.image = UIImage.init(named: "HotIconUnselected")
            
            if detailedPerson?.name == "Raúl" && detailedPerson?.surname_1 == "Montón"{
                if let filter = CIFilter(name: "CIColorInvert") {
                    filter.setValue(CIImage(image: UIImage.init(named: "HotIconUnselected")!), forKey: kCIInputImageKey)
                    let newImage = UIImage(ciImage: filter.outputImage!)
                    likedImageView.image = newImage
                }
            }
        }
        
        // Load image
        loadHresImage()
        
        // Gesture & tap handling
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        likedImageView.isUserInteractionEnabled = true
        likedImageView.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        hresPhoto.isUserInteractionEnabled = true
        hresPhoto.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
        pan.delegate = self
        hresPhoto.addGestureRecognizer(pan)

        // Author
        if detailedPerson?.isAuthor() ?? false {
            overrideUserInterfaceStyle = .dark
            hresPhotoBackground.backgroundColor = UIColor(displayP3Red: 9/255, green: 10/255, blue: 12/255, alpha: 1.0)
        }

    }
    
    // MARK: - Image loading
    
    func loadHresImage(year: String = AppState.shared.currentYear) {
        
        // Image filename creation
        
        var testString1: String
        testString1 = cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? "") + "hres")
        
        var testString2: String
        testString2 = cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? ""))
                        + cleanString(rawString: (detailedPerson?.surname_2 ?? ""))
                        + "hres"
        
        var testString3: String
        testString3 = cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? ""))
        
        if year != AppState.shared.currentYear {
            testString1 += year
            testString2 += year
            testString3 += year
        }
        
        // Setting the image
        hresPhoto.image = UIImage(encryptedFilename: testString1)
                            ?? UIImage(encryptedFilename: testString2)
                            ?? UIImage(encryptedFilename: testString3)
                            ?? UIImage(named: testString1)
                            ?? UIImage(named: "nohres")
    }

    // MARK: - Zooming

    @objc func pinch(sender:UIPinchGestureRecognizer) {
        if sender.state == .began {
            isZooming = true
            self.originalImageCenter = sender.view?.center
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
            y: sender.location(in: view).y - view.bounds.midY)
                        
            let dampedScale = sender.scale //log(sender.scale + 1)
                        
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
            .scaledBy(x: dampedScale, y: dampedScale)
            .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.hresPhoto.frame.size.width / self.hresPhoto.bounds.size.width
            var newScale = currentScale*sender.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.hresPhoto.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
        }else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            guard let center = self.originalImageCenter else {return}
            
            UIView.animate(withDuration: 0.3, animations: {
            self.hresPhoto.transform = CGAffineTransform.identity
            self.hresPhoto.center = center
            })
            
            isZooming = false

        }
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if sender.state == .began && isZooming{
            //self.originalImageCenter = sender.view?.center
        } else if sender.state == .changed && isZooming{
            
            let translation = sender.translation(in: view)
            
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.hresPhoto.superview)
        }
    }
    
    // MARK: - Favourite tap
    
    @objc func tapHandler(gesture: UITapGestureRecognizer){
        
        let impactFeedbackGenerator = UIImpactFeedbackGenerator()
        impactFeedbackGenerator.impactOccurred()
        
        if detailedPerson?.liked ?? false {
            detailedPerson?.liked = false
            likedImageView.image = UIImage.init(named: "HotIconUnselected")
            
            if detailedPerson?.name == "Raúl" && detailedPerson?.surname_1 == "Montón"{
                if let filter = CIFilter(name: "CIColorInvert") {
                    filter.setValue(CIImage(image: UIImage.init(named: "HotIconUnselected")!), forKey: kCIInputImageKey)
                    let newImage = UIImage(ciImage: filter.outputImage!)
                    likedImageView.image = newImage
                }
            }
                        
            // Set liked status
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: String(detailedPerson!.id) + "liked")
            
            
        } else {
            detailedPerson?.liked = true
            likedImageView.image = UIImage.init(named: "HotIcon")
            
            // Set liked status
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: String(detailedPerson!.id) + "liked")
        }
        
        likedImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.likedImageView.transform = .identity
            },
                       completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DATABASE_CHANGED"), object: nil)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
