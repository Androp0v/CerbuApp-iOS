//
//  LoginView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 16/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct LoginView: View {

    var body: some View {
        ZStack {

            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(UIColor(named: "MainAppColor")!),
                                                       Color(UIColor(named: "ShadowMainAppColor")!)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            // App title
            VStack {
                Spacer()
                    .frame(height: 24)

                HStack(spacing: 12) {
                    Image("becarioWhite")
                        .scaleEffect(1.5)
                    Text("CerbuApp")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(height: 24)
                .shadow(color: Color.black.opacity(0.1),
                        radius: 8,
                        x: 8,
                        y: 8)
                .padding()
                // Disable Dynamic Type for title
                .environment(\.sizeCategory, .large)

                Spacer()
            }

            // Login form content
            ScrollView {
                VStack(alignment: .center) {

                    Spacer()
                        .frame(height: 112)

                    LoginCardView()

                    Spacer()

                }
                .frame(maxWidth: 450)
                .padding(.horizontal, 24)
            }

        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.light)
    }
}
