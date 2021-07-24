//
//  LoginCardView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 23/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import FirebaseAuth
import SwiftUI

struct LoginCardView: View {

    @State private var user: String = ""
    @State private var userError: Bool = false
    @State private var password: String = ""
    @State private var passwordError: Bool = false

    // MARK: - Sign in

    /// Since Firebase Auth doesn't support sign-ins with only email and password, attach this domain at
    /// the end of every user name (the emails are not verified).
    static let workaroundDomain = "kazasjKJJ95b78ms1zee.com"

    /// Sign in a user with a user name and password.
    func signIn(userName: String, password: String) {

        let userEmail = userName + "@" + LoginCardView.workaroundDomain

        Auth.auth().signIn(withEmail: userEmail, password: password) { authResult, error in

            // Check for errors
            if let error = error {
                // Authentication failed
                guard let errorKey = error._userInfo?["FIRAuthErrorUserInfoNameKey"] as? String else { return }
                switch errorKey {
                case "ERROR_USER_NOT_FOUND":
                    // Handle user not found
                    userError = true
                    passwordError = false
                case "ERROR_WRONG_PASSWORD":
                    // Handle wrong password
                    passwordError = true
                    userError = false
                default:
                    // Handle unknown error
                    break
                }
                return
            }

            // No error directly returned from Firebase Auth
            if authResult?.user != nil {
                // Authentication succeeded
                withAnimation {
                    AppState.shared.isLoggedIn = true
                }
            } else {
                // Authentication failed

            }
        }
    }

    // MARK: - SwiftUI View
    var body: some View {
        ZStack {
            VStack() {
                VStack(spacing: 12) {
                    InputField(fieldValue: $user,
                               hasError: $userError,
                               prompt: "Usuario",
                               icon: Image(systemName: "person.fill"))
                    InputField(fieldValue: $password,
                               hasError: $passwordError,
                               prompt: "Contraseña",
                               icon: Image(systemName: "lock.fill"),
                               secure: true)
                }
                .padding(.bottom, 16)

                Button("Acceder", action: {
                    signIn(userName: user, password: password)
                })
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(UIColor.systemBlue))
                    .cornerRadius(12)

                Text("¿Has olvidado tu contraseña?")
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .padding()
            }
            .padding()
            .background(
                CardComponent()
            )
        }
    }
}

struct LoginCardView_Previews: PreviewProvider {
    static var previews: some View {
        LoginCardView()
    }
}
