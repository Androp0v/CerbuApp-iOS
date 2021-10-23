//
//  HomeContent.swift
//  
//
//  Created by Raúl Montón Pinillos on 25/7/21.
//

import SwiftUI

struct HomeContent: View {

    var body: some View {

        // Boletín
        NavigationLink(
            destination: BoletinView()
                .navigationBarTitle("Boletín semanal")
                .globalNavigationBarColor()
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.bottom)
        ) {
            MainRow(imageName: "boletinicon", text: "Boletín semanal")
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)

        // Menú
        NavigationLink(
            destination: MenuView()
                .navigationBarTitle("Menú de comedor")
                .globalNavigationBarColor()
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.bottom)
        ) {
            MainRow(imageName: "menuicon", text: "Menú de comedor")
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)

        // Pase de comidas
        NavigationLink(
            destination: BarcodeView()
                .navigationBarTitle("Pase de comidas")
                .globalNavigationBarColor()
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.bottom)
        ) {
            MainRow(imageName: "barcodeIcon", text: "Pase de comidas")
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)

        // Revista
        NavigationLink(
            destination: MagazineView()
                .navigationBarTitle("Revista Patio Interior")
                .globalNavigationBarColor()
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.bottom)
        ) {
            MainRow(imageName: "magazineicon", text: "Revista Patio Interior")
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)

        // Avisos
        NavigationLink(
            destination: NotificationsView()
                .navigationBarTitle("Avisos")
                .globalNavigationBarColor()
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.bottom)
        ) {
            MainRow(imageName: "AvisosIcon", text: "Avisos")
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
    }
}

struct HomeContent_Previews: PreviewProvider {
    static var previews: some View {
        HomeContent()
    }
}
