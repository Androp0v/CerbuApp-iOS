//
//  NavigationBarModifier.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 22/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?

    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white

    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func globalNavigationBarColor() -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: AppState.navigationBarColor))
    }

    func customNavigationBarColor(color: UIColor) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: color))
    }
}
