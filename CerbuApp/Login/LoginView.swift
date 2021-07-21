//
//  LoginView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 16/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct LoginView: View {

    @State private var user: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {

            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(UIColor(named: "MainAppColor")!),
                                                       Color(UIColor(named: "ShadowMainAppColor")!)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            // Login form content
            VStack(alignment: .center) {

                Spacer()
                    .frame(height: 24)

                HStack(spacing: 12) {
                    Image("becarioWhite")
                        .scaleEffect(1.5)
                    Text("CerbuApp")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                .shadow(color: Color.black.opacity(0.1),
                        radius: 8,
                        x: 8,
                        y: 8)
                .padding()

                Spacer()
                    .frame(height: 24)

                ZStack {

                    VStack() {
                        VStack(spacing: 12) {
                            InputField(icon: Image(systemName: "person.fill"),
                                       prompt: "Usuario",
                                       fieldValue: $user)
                            InputField(icon: Image(systemName: "lock.fill"),
                                       prompt: "Contraseña",
                                       secure: true,
                                       fieldValue: $password)
                        }
                        .padding(.bottom, 16)

                        Button("Acceder", action: {})
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

                Spacer()

            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)

        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
