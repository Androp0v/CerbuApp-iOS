//
//  ViewController.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet var orlaImageView: UIImageView!
    @IBOutlet var ContainerView: CardView!
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var test: UIView!
    @IBOutlet var ParentContainer: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cellIdentifier = "mainTableViewCellReuseID"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
        
        switch indexPath.row {
        case 0:
            cell.iconLabel.text = "Boletín semanal"
            cell.iconPhoto.image = UIImage.init(named: "boletinicon")
        case 1:
            cell.iconLabel.text = "Menú de comedor"
            cell.iconPhoto.image = UIImage.init(named: "menuicon")
        case 2:
            cell.iconLabel.text = "Revista Patio Interior"
            cell.iconPhoto.image = UIImage.init(named: "magazineicon")
        case 3:
            cell.iconLabel.text = "Avisos"
            cell.iconPhoto.image = UIImage.init(named: "AvisosIcon")
        default:
            cell.iconLabel.text = "Menu item 2"
            cell.iconPhoto.image = UIImage.init(named: "nohres")
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "pushToBoletin", sender: self)
        case 1:
            self.performSegue(withIdentifier: "pushToMenu", sender: self)
        case 2:
            self.performSegue(withIdentifier: "pushToMagazine", sender: self)
        case 3:
            self.performSegue(withIdentifier: "pushToNotifications", sender: self)
        default:
            print("Don't do anything")
        }
        mainTableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orlaImageView.layer.cornerRadius = 20.0
        ContainerView.layer.cornerRadius = 20.0
        ContainerView.layer.shadowColor = UIColor.init(named: "LighOnlyShadow")?.cgColor
        ContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        ContainerView.layer.shadowRadius = 12.0
        ContainerView.layer.shadowOpacity = 0.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        ContainerView.addGestureRecognizer(tap)
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        self.mainTableView.tableFooterView = UIView()
        
        //Height of ParentContainer has to be corrected programatically for some reason. Sorry for hacky fix
        let correctedHeight = (self.view.frame.width - 40)*(1273.0/1920.0) + 40
        ParentContainer.frame = CGRect(x:0, y: 0, width: self.view.frame.width, height: correctedHeight)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        //Same hacky fix for splitView on iPads
        let correctedHeight = (size.width - 40)*(1273.0/1920.0) + 40
        ParentContainer.frame = CGRect(x:0, y: 0, width: size.width, height: correctedHeight)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer){
        
        let touchLocation = gesture.location(in: ContainerView)
        
        //Only perform segue on releasing button
        if gesture.state == .ended {
            //Only perform segue if tap is released inside button area (and not outside)
            if ContainerView.bounds.contains(touchLocation) {
                //Clear filters
                defaults.set(false, forKey: "soloAdjuntos")
                defaults.set(false, forKey: "soloFavoritos")
                defaults.set(true, forKey: "male")
                defaults.set(true, forKey: "female")
                defaults.set(true, forKey: "nbothers")
                defaults.set(true, forKey: "100s")
                defaults.set(true, forKey: "200s")
                defaults.set(true, forKey: "300s")
                defaults.set(true, forKey: "400s")
                //Perform segue
                self.performSegue(withIdentifier: "pushFromOrla", sender: self)
            }
        }
    }
}
