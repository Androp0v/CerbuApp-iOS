//
//  LoginViewModel.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Foundation
import FirebaseAuth

struct LoginViewModel {

    /// Since Firebase Auth doesn't support sign-ins with only email and password, attach this domain at
    /// the end of every user name (the emails are not verified).
    static let workaroundDomain = "kazasjKJJ95b78ms1zee.com"

    /// Sign in a user with a user name and password.
    func signIn(userName: String, password: String) {
        Auth.auth().signIn(withEmail: userName, password: password) { authResult, error in
            // Handle authentication here
            if authResult?.user != nil {
                // Authentication succeeded

            } else {
                // Authentication failed
                
            }
        }
    }
}
