//
//  Settings.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


class Settings: ObservableObject {
    @Published var pickRandom = UserDefaults.standard.bool(forKey: "pickRandom")
    @Published var pickType = PickType(rawValue: UserDefaults.standard.string(forKey: "pickType") ?? "Chapters") ?? .chapters
    @Published var pickSections = UserDefaults.standard.object(forKey: "pickSections") as? [[String]] ?? []
    @Published var startingVerse = UserDefaults.standard.object(forKey: "startingVerse") as? [String] ??
        ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"]
    
    private var startingVerseIsSet = false
    
    func pickSectionsCount(path: [String]) -> Int {
        let filtered = pickSections.filter({ pathsAlign($0, path) })
        return filtered.count
    }
    
    func pickSectionsContains(path: [String]) -> Bool {
        return pickSectionsCount(path: path) > 0
    }
    
    /**
     Determines if one path contains the other or vice versa.
     */
    private func pathsAlign(_ path1: [String], _ path2: [String]) -> Bool {
        let minCount = path1.count < path2.count ? path1.count : path2.count
        return path1[0..<minCount] == path2[0..<minCount]
    }
    
    func addPickSection(path: [String]) {
        pickSections.append(path)
        pickSections.sort{
            scriptureTree.getNode(path: $0)!.start < scriptureTree.getNode(path: $1)!.start
        }
    }
    
    func setStartingVerse(path: [String]) {
        startingVerse = path
        startingVerseIsSet = true
    }
        
    
    // TODO: Intelligently get first path
    func updateStartingVerse() {
        if (!pickSectionsContains(path: startingVerse)) {
            startingVerseIsSet = false
        }
        
        if (!pickSections.isEmpty && !startingVerseIsSet) {
            startingVerse = pickSections.first!
            var node = scriptureTree.getNode(path: startingVerse)!
            while (!node.children.isEmpty) {
                node = node.children.first!
                startingVerse.append(node.name)
            }
            startingVerse.append("1")
        }
    }
    
    func save() {
        UserDefaults.standard.set(pickRandom, forKey: "pickRandom")
        UserDefaults.standard.set(pickType.rawValue, forKey: "pickType")
        UserDefaults.standard.set(pickSections, forKey: "pickSections")
        UserDefaults.standard.set(startingVerse, forKey: "startingVerse")
    }
}


enum PickType: String, CaseIterable, Hashable {
    case all = "All Scriptures"
    case volumes = "Volumes"
    case books = "Books"
    case chapters = "Chapters"
    case topicalGuide = "Topical Guide"
}
