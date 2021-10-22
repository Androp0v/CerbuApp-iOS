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


struct DetailsView: View {
    @State var detailedPerson: Person
    @State var personIndex: Int

    var body: some View {
        if detailedPerson.isAuthor() {
            DetailsViewContent(detailedPerson: detailedPerson, pageIndex: personIndex)
                .edgesIgnoringSafeArea(.bottom)
                .customNavigationBarColor(color: UIColor(displayP3Red: 9/255, green: 10/255, blue: 12/255, alpha: 1.0))
        } else {
            DetailsViewContent(detailedPerson: detailedPerson, pageIndex: personIndex)
                .edgesIgnoringSafeArea(.bottom)
                .globalNavigationBarColor()
        }
    }
}

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

/// Wrapper to present the view  inside a SwiftUI view
struct DetailsViewContent: UIViewControllerRepresentable {

    @State var detailedPerson: Person?
    @State var pageIndex: Int?

    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailedController.detailedPerson = detailedPerson
        detailedController.pageIndex = pageIndex
        return detailedController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

class DetailsViewController: UIViewController, UIGestureRecognizerDelegate{
    
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
        return cleanString
    }
    
    var detailedPerson: Person?
    var db: OpaquePointer?
    let defaults = UserDefaults.standard
    var originalImageCenter:CGPoint?
    var isZooming = false
    var pageIndex: Int?
    
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var hresPhoto: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var careerLabel: UILabel!
    @IBOutlet var becaImageView: UIImageView!
    @IBOutlet var likedImageView: UIImageView!
    @IBOutlet var hresPhotoBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Additional setup after loading the view.
        
        nameLabel.layer.zPosition = -1
        careerLabel.layer.zPosition = -1
        becaImageView.layer.zPosition = -1
        roomLabel.layer.zPosition = -1
        self.navigationController?.navigationBar.layer.zPosition = -1;
        
        hresPhotoBackground.backgroundColor = .systemBackground
        
        let nameLabelText: String = (detailedPerson?.name ?? "") + " " + (detailedPerson?.surname_1 ?? "")
        nameLabel.text = nameLabelText + " " + (detailedPerson?.surname_2 ?? "")
        
        if detailedPerson?.beca.isEmpty ?? true {
            careerLabel.text = detailedPerson?.career
            becaImageView = nil
            if defaults.bool(forKey: "showRooms"){
                roomLabel.text = "Habitación: " + (detailedPerson?.room ?? "?")
            }else{
                roomLabel.text = nil
            }
        }else{
            careerLabel.text = (detailedPerson?.career ?? "") + " | " + (detailedPerson?.beca ?? "")
            becaImageView.image = UIImage.init(named: "becario")
            roomLabel.text = "Habitación: " + (detailedPerson?.room ?? "?")
        }
        
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
        
        let testString1: String
        testString1 = cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? "") + "hres")
        
        let testString2: String
        let testString2a: String
        let testString2b: String
        testString2a = cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? ""))
        testString2b = cleanString(rawString: (detailedPerson?.surname_2 ?? "")) + "hres"
        testString2 = testString2a + testString2b
        
        let testString3: String
        testString3 = cleanString(rawString: (detailedPerson?.name ?? "") + (detailedPerson?.surname_1 ?? ""))
        
        hresPhoto.image = UIImage(named: testString1) ?? UIImage(named: testString2) ?? UIImage(named: testString3) ?? UIImage(named: "nohres")
        
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
            roomLabel.text = "Habitación: " + (detailedPerson?.room ?? "?")
        }

    }
   
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
    
    @objc func tapHandler(gesture: UITapGestureRecognizer){
        
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("database.db")
        if sqlite3_open_v2(finalDatabaseURL.path, &db, SQLITE_OPEN_READWRITE, nil) != SQLITE_OK {
            print("Error opening database")
        }
        
        let impactFeedbackGenerator = UIImpactFeedbackGenerator()
        impactFeedbackGenerator.impactOccurred()
        
        if detailedPerson?.liked ?? false{
            detailedPerson?.liked = false
            likedImageView.image = UIImage.init(named: "HotIconUnselected")
            
            if detailedPerson?.name == "Raúl" && detailedPerson?.surname_1 == "Montón"{
                if let filter = CIFilter(name: "CIColorInvert") {
                    filter.setValue(CIImage(image: UIImage.init(named: "HotIconUnselected")!), forKey: kCIInputImageKey)
                    let newImage = UIImage(ciImage: filter.outputImage!)
                    likedImageView.image = newImage
                }
            }
            
            let queryString = "UPDATE colegiales SET likes = 0 WHERE _id = " + String(detailedPerson!.id)
            
            if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error changing liked state: \(errmsg)")
            }
            
        }else{
            detailedPerson?.liked = true
            likedImageView.image = UIImage.init(named: "HotIcon")
            
            let queryString = "UPDATE colegiales SET likes = 1 WHERE _id = " + String(detailedPerson!.id)
            
            if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error changing liked state: \(errmsg)")
            }
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        // FIXME: navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainAppColor")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
