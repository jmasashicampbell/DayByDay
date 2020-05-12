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

var generatedScriptures = loadGeneratedScriptures()

func loadGeneratedScriptures() -> [Scripture] {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let file = path!.appendingPathComponent("ScriptureData.json")
    
    let generatedArray: [Scripture]? = try? load(file)
    return generatedArray ?? []
}

/**
  Updates scriptureData.json to reflect changes in the scriptureData array.
 */
func updateScripturesFile() {
    print("Updating", generatedScriptures.count)
    let jsonData = try! JSONEncoder().encode(generatedScriptures)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let filename = path!.appendingPathComponent("ScriptureData.json")

    do {
        try jsonString.write(to: filename, atomically: true, encoding: .utf8)
    } catch {
        fatalError("Couldn't load ScriptureData.json from main bundle:\n\(error)")
    }
}
