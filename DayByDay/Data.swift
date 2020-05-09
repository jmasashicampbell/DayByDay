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

var generatedScriptureData: [Scripture] = loadGeneratedScriptures()

func loadGeneratedScriptures() -> [Scripture] {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let file = path!.appendingPathComponent("ScriptureData.json")
    
    return load(file)
}

/**
  Updates scriptureData.json to reflect changes in the scriptureData array.
 */
func updateScripturesFile() {
    print("Updating", generatedScriptureData.count)
    let jsonData = try! JSONEncoder().encode(generatedScriptureData)
    let jsonString = String(data: jsonData, encoding: .utf8)!

    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let filename = path!.appendingPathComponent("ScriptureData.json")

    do {
        try jsonString.write(to: filename, atomically: true, encoding: .utf8)
    } catch {
        fatalError("Couldn't load ScriptureData.json from main bundle:\n\(error)")
    }
}
