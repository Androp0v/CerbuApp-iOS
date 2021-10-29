//
//  LoginView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 16/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State var cardOffset: CGFloat = .zero
    @State var showSpinner: Bool = false

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
            
            // Logging-in view
            
            if showSpinner {
                VStack(alignment: .center) {

                    Spacer()
                        .frame(height: 152)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))

                    Spacer()

                }
                .frame(maxWidth: 450)
                .padding(.horizontal, 24)
            }
            

            // Login form content
            ScrollView {
                VStack(alignment: .center) {

                    Spacer()
                        .frame(height: 112)

                    LoginCardView()
                        .edgesIgnoringSafeArea(.all)

                    Spacer()

                }
                .frame(maxWidth: 450)
                .padding(.horizontal, 24)
                .offset(y: cardOffset)
                .onReceive(AppState.shared.$loginStatus, perform: { status in
                    if status == .loggingIn {
                        withAnimation(.easeIn(duration: 1)) {
                            self.cardOffset = -5000
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.showSpinner = true
                        })
                    }
                })
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
