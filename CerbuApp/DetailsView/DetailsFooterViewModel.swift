//
//  DetailsFooterViewModel.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 22/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Combine
import Foundation

class DetailsFooterViewModel {
    @Published var detailedPerson: Person?

    init(person: Person) {
        self.detailedPerson = person
    }

    func fullNameString() -> String {

        var fullName = ""
        
        if let name = detailedPerson?.name {
            fullName.append(name)
            fullName.append(" ")
        }
        if let surname_1 = detailedPerson?.surname_1 {
            fullName.append(surname_1)
        }
        if let surname_2 = detailedPerson?.surname_2 {
            fullName.append(" ")
            fullName.append(surname_2)
        }

        return fullName
    }

    func getCareerString() -> String {

        if detailedPerson?.beca.isEmpty ?? true {
            return detailedPerson?.career ?? ""
        } else {
            return (detailedPerson?.career ?? "") + " | " + (detailedPerson?.beca ?? "")
        }
    }

    func getRoomString() -> String {

        var roomString = ""

        guard let room = detailedPerson?.room else {
            return ""
        }
        roomString.append("Habitación: ")
        roomString.append(room)
        return roomString
    }

    func getPromotionString() -> String {

        switch detailedPerson?.promotion {
        case 1:
            return "Primera promoción"
        case 2:
            return "Segunda promoción"
        case 3:
            return "Tercera promoción"
        case 4:
            return "Cuarta promoción"
        case 5:
            return "Quinta promoción"
        case 6:
            return "Sexta promoción"
        case 7:
            return "Séptima promoción"
        case 8:
            return "Octava promoción"
        case 9:
            return "Novena promoción"
        case 10:
            return "Décima promoción"
        case 99:
            return "Excolegial"
        default:
            return "Desconocido"
        }
    }

    func shouldShowRoom() -> Bool {
        let defaults = UserDefaults.standard

        if defaults.bool(forKey: "showRooms") {
            return true
        } else if !(detailedPerson?.beca.isEmpty ?? true) {
            return true
        }
        return false
    }

    func shouldEnablePromotionsButton() -> Bool {
        guard let detailedPerson = detailedPerson else {
            return false
        }

        if detailedPerson.promotion == 1 || detailedPerson.promotion == 99 {
            return false
        }

        return true
    }
}
