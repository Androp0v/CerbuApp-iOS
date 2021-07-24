//
//  InputField.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct InputField: View {

    @Binding var fieldValue: String
    @Binding var hasError: Bool

    let prompt: String
    var icon: Image?
    var secure: Bool = false

    var body: some View {
        HStack {
            if let icon = icon {
                icon
                    .foregroundColor( hasError ? .red : Color(UIColor.label) )
            }
            if !secure {
                TextField(prompt, text: $fieldValue)
            } else {
                SecureField(prompt, text: $fieldValue)
            }
        }
        .padding()
        .background(
            ZStack {
                if hasError {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.red, lineWidth: 4.0)
                }
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(UIColor.systemBackground).opacity(0.8))
            }
        )
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(fieldValue: .constant(""),
                   hasError: .constant(true),
                   prompt: "Prompt",
                   icon: Image(systemName: "person.fill"))
    }
}
