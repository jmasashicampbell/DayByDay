//
//  ScriptureGenerator.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/5/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


/**
  Generates a scripture if one hasn't been generated for that day. Adds that scripture to scriptureList and updates scriptureData.json.
 */
func generateScripture() {
    print("Generating", generatedScriptureData.count)
    if (generatedScriptureData.isEmpty) {
        let scriptureIndex = 31196
        let newScripture = newScriptureFromIndex(index: scriptureIndex, id: 1001)
        generatedScriptureData.append(newScripture)
        updateScripturesFile()
    }
    else {
        let lastScripture : Scripture = generatedScriptureData.last!
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        if (today != lastScripture.date) {
            let newScripture = newScriptureFromIndex(index: lastScripture.index + 1, id: lastScripture.id + 1)
            generatedScriptureData.append(newScripture)
            updateScripturesFile()
        }
    }
}


/**
  Creates a new Scripture struct given and index and an id.
 
  - Parameter index: The index of the scripture in scriptures.json
  - Parameter id: The id to assign to the object
 
  - Returns: The new Scripture struct
 */
func newScriptureFromIndex(index: Int, id: Int) -> Scripture {
    struct Verse: Codable {
        var reference: String
        var text: String
        var verse: Int
    }

    let file = bundleUrlFromFilename("scriptures.json")
    let scripturesArray: [Verse] = load(file)
    
    let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    let newVerse = scripturesArray[index]
    let newScripture = Scripture(id: id,
                                 date: today,
                                 reference: newVerse.reference,
                                 text: newVerse.text,
                                 notes: "",
                                 index: index)
    return newScripture
}


