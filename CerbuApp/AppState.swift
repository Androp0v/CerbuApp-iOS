//
//  AppState.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 24/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Foundation
import UIKit

class AppState: ObservableObject {

    static let shared = AppState()

    // MARK: - Properties

    static let navigationBarColor: UIColor = UIColor(named: "MainAppColor")!

    @Published var isLoggedIn: Bool = false
    var peopleDatabase: PeopleDatabaseManager?


    // MARK: - Initialization

    init(){
        peopleDatabase = PeopleDatabaseManager()
    }

}
