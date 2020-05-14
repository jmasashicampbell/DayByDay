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


class GeneratedScriptures: ObservableObject {
    @Published var array: [Scripture]
    let NUM_FUTURE_SCRIPTURES = 30
    
    
    init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let file = path!.appendingPathComponent("ScriptureData.json")
        
        let loadedArray: [Scripture]? = try? load(file)
        array = loadedArray ?? []
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
    
    
    /**
     Generates new Scriptures based on settings for the next NUM_FUTURE_SCRIPTURES days.
     - Parameter force: If true, generates for all future dates. If false, only generates for dates not yet generated.
     */
    func update(force: Bool = false) {
        if (force) {
            array = getPast()
        }
        
        let today = makeComponents(date: Date())
        let generatedDates = array.map { $0.date }
        for date in dateRange(startDate: today, size: NUM_FUTURE_SCRIPTURES) {
            if (!generatedDates.contains(date)) {
                generateScripture(date: date)
            }
        }
        save()
    }
    
    
    func generateScripture(date: DateComponents) {
        let settings = Settings()
        let currentSections = settings.getCurrentSections()
        let newIndex: Int
        var versesPool: [Int] = []

        if (currentSections.isEmpty) {
            versesPool = Array(0..<scriptureArray.count)
        } else {
            for path in currentSections {
                let node = scriptureTree.getNode(path: path)!
                versesPool += Array(node.start..<node.end)
            }
        }

        if (settings.pickRandom) {
            newIndex = versesPool.randomElement()!
        } else {
            let startIndex = indexFrom(path: settings.getStartingVerse())
            let dateDifference = differenceInDays(date, settings.startDateComponents)
            let startIndexInPool = versesPool.firstIndex(of: startIndex)!
            newIndex = versesPool[(startIndexInPool + dateDifference) % versesPool.count]
        }
        
        let id = array.isEmpty ? 1001 : array.last!.id + 1

        let newScripture = Scripture(index: newIndex, id: id, date: date)
        array.append(newScripture)
    }

    
    func save() {
        let jsonData = try! JSONEncoder().encode(array)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = path!.appendingPathComponent("ScriptureData.json")

        do {
            try jsonString.write(to: filename, atomically: true, encoding: .utf8)
        } catch {
            fatalError("Couldn't write ScriptureData.json to documents directory:\n\(error)")
        }
    }
    
    
    /**
     Gets the index of the scripture represented by a path.
     - Parameter path: The path representing the scripture
     - Returns: The index of the scripture in scriptures.json
     */
    private func indexFrom(path: [String]) -> Int {
        var node: Node? = scriptureTree.root
        for name in path[1 ..< path.count - 1] {
            node = node!.getChild(name: name)
            if (node == nil) {
                fatalError("Invalid path \(path)")
            }
        }
        return node!.start + Int(path.last!)! - 1
    }


    private func differenceInDays(_ dateComp1: DateComponents, _ dateComp2: DateComponents) -> Int {
        let date1 = Calendar.current.date(from: dateComp1)!
        let date2 = Calendar.current.date(from: dateComp2)!
        return Int(date1.timeIntervalSinceReferenceDate - date2.timeIntervalSinceReferenceDate) / SECONDS_IN_DAY
    }
    
    
    private func dateRange(startDate: DateComponents, size: Int) -> [DateComponents] {
        
        func addDays(_ dateComponents: DateComponents, days: Int) -> DateComponents {
            let date = Calendar.current.date(from: dateComponents)!
            let newDateInterval = date.timeIntervalSinceReferenceDate + Double(SECONDS_IN_DAY * days)
            let newDate = Date(timeIntervalSinceReferenceDate: newDateInterval)
            return makeComponents(date: newDate)
        }
        
        let range = 0 ..< size
        return range.map { addDays(startDate, days: $0) }
    }
}
