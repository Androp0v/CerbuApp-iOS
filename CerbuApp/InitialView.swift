//
//  InitialView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 24/7/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

// MARK: - MainView

/// Wrapper to present the main Storyboard entry point inside a SwiftUI view
struct MainView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update this VC from SwiftUI as of now
    }
}

// MARK: - InitialView

/// View to automatically show the login view or the main app interface (loaded from a Storyboard)
struct InitialView: View {

    @ObservedObject private var appState = AppState.shared

    var body: some View {
        if appState.isLoggedIn {
            MainView()
                .edgesIgnoringSafeArea(.all)
        } else {
            LoginView()
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
