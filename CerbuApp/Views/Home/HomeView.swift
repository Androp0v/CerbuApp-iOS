//
//  HomeView.swift
//  
//
//  Created by Raúl Montón Pinillos on 24/7/21.
//

import Firebase
import SwiftUI

struct HomeView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showSettings = false
    @State private var navigationBarColor = UIColor(named: "MainAppColor")!

    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    var body: some View {
        NavigationView {

            GeometryReader { geometry in

                // Sidebar in master-detail mode, initial view
                // in other modes
                if horizontalSizeClass == .compact {

                    List {

                        // Orla colegial
                        NavigationLink(
                            destination: OrlaView()
                        ) {
                            OrlaRowView(listWidth: geometry.size.width)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)

                        HomeContent()
                    }
                    .listStyle( PlainListStyle() )
                    .navigationBarTitle("CerbuApp")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(
                        NavigationLink(
                            destination: SettingsView()
                                .navigationBarTitle("Ajustes")
                                .globalNavigationBarColor()
                                .navigationBarTitleDisplayMode(.inline)
                                .edgesIgnoringSafeArea(.bottom), isActive: $showSettings) {
                          EmptyView()
                        }
                    )
                    .toolbar {
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(Font.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }

                } else {

                    List {
                        
                        // Orla colegial
                        NavigationLink(
                            destination: OrlaView()
                        ) {
                            OrlaRowView(listWidth: geometry.size.width)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)

                        HomeContent()
                    }
                    .listStyle( SidebarListStyle() )
                    .navigationBarTitle("CerbuApp")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(
                        NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                          EmptyView()
                        }
                        .navigationBarTitle("Ajustes")
                        .navigationBarTitleDisplayMode(.inline)
                        .edgesIgnoringSafeArea(.bottom)
                    )
                    .toolbar {
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(Font.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }

                }
            }
            .globalNavigationBarColor()

            // Initial view in master-detail mode
            OrlaView()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            let defaults = UserDefaults.standard

            // Create a "unique" user ID if none was set
            if defaults.object(forKey: "userID") == nil{
                defaults.setValue(randomString(length: 16), forKey: "userID")
            }

            // Subscribe to Firebase topic "all" where "all" the notifications are streamed
            Messaging.messaging().subscribe(toTopic: "all")

            //Clear filters
            defaults.set(false, forKey: "soloAdjuntos")
            defaults.set(false, forKey: "soloFavoritos")
            defaults.set(true, forKey: "male")
            defaults.set(true, forKey: "female")
            defaults.set(true, forKey: "nbothers")
            defaults.set(true, forKey: "100s")
            defaults.set(true, forKey: "200s")
            defaults.set(true, forKey: "300s")
            defaults.set(true, forKey: "400s")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
