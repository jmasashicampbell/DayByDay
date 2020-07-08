//
//  Scripture.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Scripture: Codable, Identifiable {
    var id: Int
    var date: DateComponents
    var reference: String
    var text: String
    var notes: String
    var index: Int
    
    init(index: Int, id: Int, date: DateComponents) {
        let newVerse = scriptureArray[index]
        self.id = id
        self.date = date
        self.reference = newVerse.reference
        self.text = newVerse.text
        self.notes = ""
        self.index = index
    }
}
