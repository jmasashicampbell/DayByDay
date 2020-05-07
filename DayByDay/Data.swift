//
//  Data.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation

var scriptureData: [Scripture] = loadScriptures("ScriptureData.json")

func loadScriptures(_ filename: String) -> [Scripture] {
    let data: Data
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let file = path!.appendingPathComponent("ScriptureData.json")
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        return []
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([Scripture].self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \([Scripture].self):\n\(error)")
    }
}

/**
  Updates scriptureData.json to reflect changes in the scriptureData array.
 */
func updateScripturesFile() {
    print("Updating", scriptureData.count)
    let jsonData = try! JSONEncoder().encode(scriptureData)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let filename = path!.appendingPathComponent("ScriptureData.json")

    do {
        try jsonString.write(to: filename, atomically: true, encoding: .utf8)
    } catch {
        fatalError("Couldn't load ScriptureData.json from main bundle:\n\(error)")
    }
}
