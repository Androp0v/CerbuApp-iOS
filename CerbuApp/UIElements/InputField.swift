//
//  InputField.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct InputField: View {

    var icon: Image?
    let prompt: String
    var secure: Bool = false
    @Binding var fieldValue: String

    var body: some View {
        HStack {
            if let icon = icon {
                icon
                    .foregroundColor(Color(UIColor.label))
            }
            if !secure {
                TextField(prompt, text: $fieldValue)
            } else {
                SecureField(prompt, text: $fieldValue)
            }
        }
        .padding()
        .background(
            Rectangle()
                .foregroundColor(Color(UIColor.systemBackground).opacity(0.8))
                .cornerRadius(12)
        )
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(icon: Image(systemName: "person.fill"),
                   prompt: "Prompt",
                   fieldValue: .constant(""))
    }
}
