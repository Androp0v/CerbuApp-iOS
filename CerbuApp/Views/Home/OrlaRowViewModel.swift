//
//  OrlaRowViewModel.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 22/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Foundation
import SwiftUI

struct OrlaRowViewModel {

    var imageName: String

    init() {

        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let currentMonth = components.month
        let currentDay = components.day

        self.imageName = "orlabackground"

        // Christmas skin: 23rd of December to 7th of January
        if currentMonth == 12 && currentDay! > 23 {
            self.imageName = "orlabackground_christmas"
        }
        if currentMonth == 1 && currentDay! < 7 {
            self.imageName = "orlabackground_christmas"
        }
    }

}
