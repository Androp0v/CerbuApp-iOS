//
//  CardComponent.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct CardComponent: View {
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Color.clear
                .background(.thinMaterial)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1),
                        radius: 8,
                        x: 8,
                        y: 8)
        } else {
            Color(UIColor.secondarySystemBackground)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1),
                        radius: 8,
                        x: 8,
                        y: 8)
        }
    }
}

struct CardComponent_Previews: PreviewProvider {
    static var previews: some View {
        CardComponent()
            .preferredColorScheme(.light)
    }
}
