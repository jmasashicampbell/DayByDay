//
//  ScriptureGenerator.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/5/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI


/**
  Generates a scripture if one hasn't been generated for the specified day. Adds that scripture to scriptureList and updates scriptureData.json.
 - Parameter date: The date for which to generate a scripture as a DateComponent
 */
func generateScripture(date: DateComponents) {
    if (!generatedScriptures.map { $0.date }.contains(date)) {
        let settings = Settings()
        let newIndex: Int
        var versesPool: [Int] = []

        if (settings.pickType == .all || settings.pickSections.isEmpty) {
            versesPool = Array(0..<scriptureArray.count)
        } else {
            for path in settings.pickSections {
                let node = scriptureTree.getNode(path: path)!
                versesPool += Array(node.start..<node.end)
            }
        }

        if (settings.pickRandom) {
            newIndex = versesPool.randomElement()!
        } else {
            let startIndex = indexFrom(path: settings.startingVerse)
            let dateDifference = differenceInDays(date, settings.startDateComponents)
            newIndex = versesPool[versesPool.firstIndex(of: startIndex)! + dateDifference]
        }
        
        let id = generatedScriptures.isEmpty ? 1001 : generatedScriptures.last!.id + 1

        let newScripture = Scripture(index: newIndex, id: id, date: date)
        generatedScriptures.append(newScripture)
        updateScripturesFile()
    }
}


/**
 Gets the index of the scripture represented by a path.
 - Parameter path: The path representing the scripture
 - Returns: The index of the scripture in scriptures.json
 */
func indexFrom(path: [String]) -> Int {
    var node: Node? = scriptureTree.root
    for name in path[1 ..< path.count - 1] {
        node = node!.getChild(name: name)
        if (node == nil) {
            fatalError("Invalid path \(path)")
        }
    }
    return node!.start + Int(path.last!)! - 1
}


func differenceInDays(_ dateComp1: DateComponents, _ dateComp2: DateComponents) -> Int {
    let date1 = Calendar.current.date(from: dateComp1)!
    let date2 = Calendar.current.date(from: dateComp2)!
    return Int(date1.timeIntervalSinceReferenceDate - date2.timeIntervalSinceReferenceDate) / 86400
}
