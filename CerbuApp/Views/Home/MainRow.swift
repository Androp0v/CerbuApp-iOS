//
//  MainRow.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 24/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct MainRow: View {

    var imageName: String
    var text: String

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 48)

            Image(imageName, bundle: nil)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)

            Spacer()
                .frame(width: 24)

            Text(text)
                .font(.system(size: 20))

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct MainRow_Previews: PreviewProvider {
    static var previews: some View {
        MainRow(imageName: "boletinicon", text: "Example")
    }
}
