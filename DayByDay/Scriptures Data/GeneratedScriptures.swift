//
//  Data.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import UIKit
import SwiftUI


class GeneratedScriptures: ObservableObject {
    @Published var array: [Scripture] = []
    let NUM_FUTURE_SCRIPTURES = 60
    
    
    init() {
        do {
            try update()
        } catch {
            print("Unable to initialize GeneratedScriptures with saved values: ", error)
        }
    }
    
    
    // For previews
    init(array: [Scripture]) {
        self.array = array
    }
    
    
    func getPast() -> [Scripture] {
        let today = makeComponents(date: Date())
        return array.filter { $0.date <= today }
    }
    
    
    func getFuture() -> [Scripture] {
        let today = makeComponents(date: Date())
        return array.filter { $0.date > today }
    }
    
    
    func get(date: Date) -> Scripture? {
        let dateDay = makeComponents(date: date)
        return array.filter { $0.date == dateDay }.first
    }
    
    
    
    func update() throws {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let file = path!.appendingPathComponent("ScriptureData.json")
        
        let loadedArray: [Scripture]? = try load(file)
        array = loadedArray ?? []
    }

}

struct Scripture: Codable, Identifiable {
    var id: Int
    var date: DateComponents
    var reference: String
    var text: String
    var notes: String
    var index: Int
}

