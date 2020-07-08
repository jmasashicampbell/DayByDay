//
//  ScriptureCompletionArray.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation

import Foundation


class ScriptureCompletion {
    var array: [Bool]
    
    init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let file = path!.appendingPathComponent("ScriptureCompletionArray.json")
        if FileManager.default.fileExists(atPath: file.path) {
            array = try! load(file)
        } else {
            let numVerses = scriptureTree.root.end
            array = Array(repeating: false, count: numVerses)
            save()
        }
    }
    
    func updateArray(_ generatedScriptures: GeneratedScriptures) {
        for scripture in generatedScriptures.array {
            print("Index", scripture.index)
            array[scripture.index] = true
        }
        save()
    }
    
    func getCompletedNum(_ range: Node) -> Int {
        let selectedArray = Array(array[range.start..<range.end])
        return selectedArray.reduce(0, { $1 ? $0 + 1: $0 })
    }
    
    func save() {
        let jsonData = try! JSONEncoder().encode(array)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = path!.appendingPathComponent("ScriptureCompletionArray.json")

        do {
            try jsonString.write(to: filename, atomically: true, encoding: .utf8)
        } catch {
            fatalError("Couldn't write ScriptureCompletionArray.json to documents directory:\n\(error)")
        }
    }
}

