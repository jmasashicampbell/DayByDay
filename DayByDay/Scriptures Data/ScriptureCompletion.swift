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
        let numVerses = scriptureTree.root.end
        array = Array(repeating: false, count: numVerses)
    }
    
    func updateArray(_ generatedScriptures: GeneratedScriptures) {
        for scripture in generatedScriptures.getPast() {
            array[scripture.index] = true
        }
    }
    
    func getCompletedNum(_ range: Node) -> Int {
        let selectedArray = Array(array[range.start..<range.end])
        return selectedArray.reduce(0, { $1 ? $0 + 1: $0 })
    }
}

