//
//  Person.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 22/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class Person {
    
    //MARK: Properties
    
    var id: Int
    var name: String
    var surname_1: String
    var surname_2: String
    var career: String
    var beca: String
    var room: String
    var floor: Int
    var liked: Bool
    var gender: Int
    var promotion: Int

    var iconPhoto: UIImage?
    
    //MARK: Initialization
    
    init?(id: Int, name: String, surname_1: String, surname_2: String, career: String, beca: String, room: String, floor: Int, liked: Bool, gender: Int, promotion: Int) {
        
        if name.isEmpty {
            return nil
        }
        
        self.id = id
        self.name = name
        self.surname_1 = surname_1
        self.surname_2 = surname_2
        self.career = career
        self.beca = beca
        self.room = room
        self.floor = floor
        self.liked = liked
        self.gender = gender
        self.promotion = promotion
    }

    init?(id: String, data: NSDictionary) {

        guard let id = Int(id) else { return nil }
        guard let name = data["name"] as? String else { return nil }

        self.id = id
        self.name = name
        self.surname_1 = data["surname_1"] as? String ?? ""
        self.surname_2 = data["surname_2"] as? String ?? ""
        self.career = data["career"] as? String ?? ""
        self.beca = data["beca"] as? String ?? ""
        self.room = data["room"] as? String ?? ""
        self.floor = data["floor"] as? Int ?? 0
        self.liked = false // TO-DO
        self.gender = data["gender"] as? Int ?? 0
        self.promotion = data["promotion"] as? Int ?? 0
    }

    // MARK: - Getters

    func getName() -> String {
        return self.name
    }

    func isAuthor() -> Bool {
        if self.name == "Raúl" && self.surname_1 == "Montón" && self.surname_2 == "Pinillos" {
            return true
        }
        return false
    }
    
}
