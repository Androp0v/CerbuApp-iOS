//
//  LoginCardView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 23/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct LoginCardView: View {

    @Binding var user: String
    @Binding var password: String

    var body: some View {
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
    }
}

struct LoginCardView_Previews: PreviewProvider {
    static var previews: some View {
        LoginCardView(user: .constant(""), password: .constant(""))
    }
}
