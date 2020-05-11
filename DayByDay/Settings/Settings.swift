//
//  Settings.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation

enum PickType: String, CaseIterable, Hashable {
    case all = "All Scriptures"
    case volumes = "Volumes"
    case books = "Books"
    case chapters = "Chapters"
    case topicalGuide = "Topical Guide"
}

class Settings: ObservableObject {
    @Published var references: [[String]] = []
    @Published var startingVerse = StartingVerse(volume: "", book: "", chapter: "", verse: 0)
    
    func referencesCount(path: [String]) -> Int {
        let filtered = references.filter({ pathsAlign($0, path) })
        return filtered.count
    }
    
    /**
     Determines if one path contains the other or vice versa.
     */
    private func pathsAlign(_ path1: [String], _ path2: [String]) -> Bool {
        let minCount = path1.count < path2.count ? path1.count : path2.count
        return path1[0..<minCount] == path2[0..<minCount]
    }
    
    func referencesContains(path: [String]) -> Bool {
        return referencesCount(path: path) > 0
    }
    
    func updateStartingVerse() {
        let startingPath = getStartingPath()
        if (!self.references.isEmpty && !self.referencesContains(path: startingPath)) {
            var firstPath = references[0]
            var node = scriptureTree.getNode(path: firstPath)!
            while (!node.children.isEmpty) {
                node = node.children[0]
                firstPath.append(node.name)
            }
            
            let fromDAndC = startingVerse.volume == "Doctrine and Covenants"
            startingVerse.volume = firstPath[1]
            startingVerse.book = fromDAndC ? "" : firstPath[2]
            startingVerse.chapter = fromDAndC ? firstPath[2] : firstPath[3]
            startingVerse.verse = 0
        }
    }
    
    func getStartingPath() -> [String] {
        return (startingVerse.volume == "Doctrine and Covenants"
                ? ["Scriptures", startingVerse.volume, startingVerse.book, startingVerse.chapter]
                : ["Scriptures", startingVerse.volume, startingVerse.chapter])
    }
}

struct StartingVerse {
    var volume: String
    var book: String
    var chapter: String
    var verse: Int
}
