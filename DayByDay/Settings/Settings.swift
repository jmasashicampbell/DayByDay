//
//  Settings.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


class Settings: ObservableObject {
    @Published var references: [[String]] = []
    @Published var startingVerse = ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"]
    var startingVerseIsSet = false
    
    func referencesCount(path: [String]) -> Int {
        let filtered = references.filter({ pathsAlign($0, path) })
        return filtered.count
    }
    
    func referencesContains(path: [String]) -> Bool {
        return referencesCount(path: path) > 0
    }
    
    /**
     Determines if one path contains the other or vice versa.
     */
    private func pathsAlign(_ path1: [String], _ path2: [String]) -> Bool {
        let minCount = path1.count < path2.count ? path1.count : path2.count
        return path1[0..<minCount] == path2[0..<minCount]
    }
    
    func addReference(path: [String]) {
        references.append(path)
        references.sort{
            scriptureTree.getNode(path: $0)!.start < scriptureTree.getNode(path: $1)!.start
        }
    }
    
    func setStartingVerse(path: [String]) {
        startingVerse = path
        startingVerseIsSet = true
    }
        
    
    // TODO: Intelligently get first path
    func updateStartingVerse() {
        if (!referencesContains(path: startingVerse)) {
            startingVerseIsSet = false
        }
        
        if (!references.isEmpty && !startingVerseIsSet) {
            startingVerse = references.first!
            var node = scriptureTree.getNode(path: startingVerse)!
            while (!node.children.isEmpty) {
                node = node.children.first!
                startingVerse.append(node.name)
            }
            startingVerse.append("1")
        }
    }
}


enum PickType: String, CaseIterable, Hashable {
    case all = "All Scriptures"
    case volumes = "Volumes"
    case books = "Books"
    case chapters = "Chapters"
    case topicalGuide = "Topical Guide"
}
