//
//  PeopleDatabaseManager.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 22/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Firebase
import FirebaseAuth
import Foundation

class PeopleDatabaseManager {

    /// Wether the database has loaded
    var databaseStatus: DatabaseStatus = .notLoaded
    public enum DatabaseStatus {
        case notLoaded
        case loading
        case loaded
    }

    /// Root node containing all people data
    private let peopleRoot: DatabaseReference
    /// Node containing people data for a given year
    private let currentYearNode: DatabaseReference
    /// Complete list of people
    private var peopleList = [Person]()

    // MARK: - Initialization

    init?() {
        guard Auth.auth().currentUser?.uid != nil else {
            NSLog("Unable to open database: User not logged in")
            return nil
        }

        // Enable on-disk persistency
        Database.database().isPersistenceEnabled = true

        self.peopleRoot = Database.database().reference().child("People")
        self.currentYearNode = peopleRoot.child("20202021")

        // Keep people data synced
        self.peopleRoot.keepSynced(true)

        loadPeopleData()
    }

    // MARK: - Public functions

    public func getSortedPeople() -> [Person]? {
        return sortedPeople(people: peopleList)
    }

    public func getSortedPromotion(promotion: Int) -> [Person]? {
        if promotion < 5 {
            return sortedPeople(people: peopleList.filter({ person in
                return person.promotion == promotion
            }))
        } else {
            return sortedPeople(people: peopleList.filter({ person in
                return person.promotion >= promotion
            }))
        }
    }

    // MARK: - sortedPeople functions

    private func sortedPeople(people: [Person]) -> [Person]? {
        
        // Sort them by name or surname based on user preferences
        let defaults = UserDefaults.standard
        var nameFirst = true
        if defaults.bool(forKey: "surnameFirst"){
            nameFirst = false
        }

        // Sorting
        if nameFirst {
            let sortedPeople = people.sorted(by: {
                $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
            })
            return sortedPeople
        } else {
            let sortedPeople = people.sorted(by: {
                $0.surname_1.localizedCaseInsensitiveCompare($1.surname_1) == ComparisonResult.orderedAscending
            })
            return sortedPeople
        }
    }

    private func loadPeopleData() {
        // Mark the database as loading
        databaseStatus = .loading

        // Sync database with server or retrieve cached value
        currentYearNode.observeSingleEvent(of: .value, with: { snapshot in
            for personAny in snapshot.children {

                // Cast AnyObject to DataSnapshot
                let personSnapshot = personAny as? DataSnapshot
                guard let personSnapshot = personSnapshot else {
                    continue
                }

                // Retrieve person id and data
                let personId = personSnapshot.key
                let personDict = personSnapshot.value as? NSDictionary
                guard let personDict = personDict else {
                    continue
                }

                // Create a the person object
                let person = Person(id: personId, data: personDict)
                guard let person = person else {
                    continue
                }

                // Append person to list
                self.peopleList.append(person)

                // Mark the database as loaded
                self.databaseStatus = .loaded
            }
        })

        // Inject author if discovered
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "InjectAuthor") {
            peopleList.append(Person(id: -1,
                                     name: "Raúl",
                                     surname_1: "Montón",
                                     surname_2: "Pinillos",
                                     career: "Física",
                                     beca: "Asociación Antiguos Colegiales (2019-2020)",
                                     room: "Excolegial",
                                     floor: -1,
                                     liked: false,
                                     gender: 0,
                                     promotion: 99)!)
        }
    }
}
