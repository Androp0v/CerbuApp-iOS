//
//  CustomSeparator.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 21/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct HomeRowSeparator: View {
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 96)
            Color(UIColor.separator)
                .frame(height: 1)
        }
    }
}

struct HomeRowSeparator_Previews: PreviewProvider {
    static var previews: some View {
        HomeRowSeparator()
    }
}
