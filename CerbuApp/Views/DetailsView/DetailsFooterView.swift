//
//  DetailsFooterView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 22/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import SwiftUI

struct DetailsFooterView: View {

    @State var showingPhotoPicker: Bool = false
    @State var selection: Int = 0
    var model: DetailsFooterViewModel
    var container: DetailsViewController?

    var body: some View {
        ScrollView{
            VStack(spacing: 8) {

                Spacer()
                    .frame(height: 24)

                Text(model.fullNameString())
                    .font(.system(size: 30,
                                  weight: .bold,
                                  design: .default))
                    .multilineTextAlignment(.center)

                Text(model.getCareerString())
                    .multilineTextAlignment(.center)

                Button(action: {
                    showingPhotoPicker = true
                }) {
                    HStack(spacing: 4){
                        Text(model.getPromotionString())
                        if model.shouldEnablePromotionsButton() {
                            Image(systemName: "clock.arrow.circlepath")
                        }
                    }
                }
                .buttonStyle(.bordered)
                .disabled(!model.shouldEnablePromotionsButton())
                .confirmationDialog("Elije una promoción",
                                    isPresented: $showingPhotoPicker,
                                    titleVisibility: .visible) {
                    Button("2021-2022") {
                        selection = 0
                        container?.loadHresImage(year: "2021")
                    }

                    Button("2020-2021") {
                        selection = 1
                        container?.loadHresImage(year: "2020")
                    }
                }
                
                if model.shouldShowRoom() {
                    Text(model.getRoomString())
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .multilineTextAlignment(.center)
                }
                
                if model.shouldShowBeca() {
                    Image("becario")
                        .resizable()
                        .frame(width: 48, height: 48)
                }

                Spacer()
            }
            .padding(.horizontal, 18)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DetailsFooterView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsFooterView(model: DetailsFooterViewModel(person: Person(id: 0, name: "Nombre", surname_1: "Apellido", surname_2: "Apellido", career: "Ingeniería Aeroespacial", beca: "", room: "402", floor: 400, liked: false, gender: 0, promotion: 2)!))
    }
}
