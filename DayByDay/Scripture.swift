//
//  Scripture.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Scripture: Hashable, Codable, Identifiable {
    var id: Int
    var date: Date
    var reference: String
    var text: String
    var notes: String
}
