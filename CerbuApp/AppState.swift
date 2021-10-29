//
//  AppState.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 24/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Combine
import Firebase
import Foundation
import SwiftUI
import UIKit

class AppState: ObservableObject {

    static let shared = AppState()

    // MARK: - Properties

    static let navigationBarColor: UIColor = UIColor(named: "MainAppColor")!

    @Published var loginStatus: LoginStatus = .notLoggedIn
    var peopleDatabase: PeopleDatabaseManager?
    var decryptionManager: DecryptionManager?
    var currentYear: String {
        // TO-DO: Remove hardcoded value
        return "2021"
    }
    
    private var databaseCancellable: AnyCancellable?
    private var decryptionKeyCancellable: AnyCancellable?


    // MARK: - Initialization

    init(){
        // Enable on-disk persistency
        Database.database().isPersistenceEnabled = true
        // Initialize managers
        peopleDatabase = PeopleDatabaseManager()
        decryptionManager = DecryptionManager()
    }
    
    func waitForNonEmptyData() {
        peopleDatabase = PeopleDatabaseManager()
        databaseCancellable = peopleDatabase?.$databaseStatus.sink(receiveValue: { databaseStatus in
            if databaseStatus == .loaded && self.decryptionManager?.decryptionKeyStatus == .retrieved {
                withAnimation {
                    self.loginStatus = .loggedIn
                }
            }
        })
        decryptionManager = DecryptionManager()
        decryptionKeyCancellable = decryptionManager?.$decryptionKeyStatus.sink(receiveValue: { decrytionKeyStatus in
            if decrytionKeyStatus == .retrieved && self.peopleDatabase?.databaseStatus == .loaded {
                withAnimation {
                    self.loginStatus = .loggedIn
                }
            }
        })
    }

}

enum LoginStatus {
    case notLoggedIn
    case loggingIn
    case loggedIn
}
