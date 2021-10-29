//
//  OrlaRowView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 21/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct OrlaRowView: View {

    @State var listWidth: CGFloat
    @State var orlaRowViewModel = OrlaRowViewModel()
    private let leadingTrailingPadding: CGFloat = 20
    private let extraTopPadding: CGFloat = 8
    private let extraBottomPadding: CGFloat = 8

    var body: some View {
        VStack {
            Spacer()
                .frame(height: extraTopPadding)
            ZStack {
                Image(orlaRowViewModel.imageName)
                        .resizable()
                HStack {
                    VStack {
                        Text("Orla colegial")
                            .foregroundColor(.white)
                            .font(.system(size: 30,
                                          weight: .bold,
                                          design: .default))
                            .padding()

                        Spacer()
                    }
                    Spacer()
                }
            }
            .frame(width: listWidth - 2 * leadingTrailingPadding,
                   height: (listWidth - 2 * leadingTrailingPadding) * 0.66)
            .cornerRadius(24)
            .shadow(color: Color(UIColor(named: "LightOnlyShadow")!),
                    radius: 12.0,
                    x: 0.0,
                    y: 0.0)
            Spacer()
                .frame(height: extraBottomPadding)
        }
        .frame(width: listWidth,
               height: listWidth * 0.66 + extraTopPadding + extraBottomPadding)
        //.background(Color(UIColor.systemBackground))
    }
}

struct OrlaRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrlaRowView(listWidth: 300)
    }
}
