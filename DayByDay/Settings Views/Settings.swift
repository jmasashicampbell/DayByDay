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
    @Published var pickType = PickType(rawValue: UserDefaults.standard.string(forKey: "pickType") ?? "Chapters") ?? .all
    @Published var pickSections = UserDefaults.standard.object(forKey: "pickSections") as? Dictionary<String, [[String]]> ?? ["Volumes": [], "Books": [], "Chapters": [], "Topical Guide": []]
    @Published var startingVerse = UserDefaults.standard.object(forKey: "startingVerse") as? Dictionary<String, [String]> ??
        ["Volumes": ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"],
         "Books": ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"],
         "Chapters": ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"],
         "Topical Guide": ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"]]
         
    var startDateComponents: DateComponents
    private var startingVerseIsSet = true
    
    @Published var notificationsOn = UserDefaults.standard.bool(forKey: "notificationsOn")
    @Published var notificationsTime = UserDefaults.standard.object(forKey: "notificationsTime") as? Date ?? Date()
    
    @Published var themeColor = ThemeColor(color: ThemeColorOptions(rawValue: UserDefaults.standard.string(forKey: "themeColor") ?? "blue") ?? .blue)
    
    
    init() {
        let startDate = UserDefaults.standard.object(forKey: "startDate") as? Date ?? Date()
        self.startDateComponents = makeComponents(date: startDate)
    }
    
    
    func getCurrentSections() -> [[String]] {
        return pickSections[pickType.rawValue] ?? []
    }
    
    
    func pickSectionsCount(path: [String]) -> Int {
        let currentSections = pickSections[pickType.rawValue] ?? []
        let filtered = currentSections.filter({ pathsAlign($0, path) })
        return filtered.count
    }
    
    
    func pickSectionsContains(path: [String]) -> Bool {
        return pickSectionsCount(path: path) > 0
    }
    
    
    func addPickSection(path: [String]) {
        if (pickSections[pickType.rawValue] != nil) {
            pickSections[pickType.rawValue]!.append(path)
            pickSections[pickType.rawValue]!.sort{
                scriptureTree.getNode(path: $0)!.start < scriptureTree.getNode(path: $1)!.start
            }
            updateStartingVerse()
        } else {
            fatalError("Tried to add to pickSections with pickType \(pickType.rawValue)")
        }
    }
    
    
    func removePickSection(path: [String]) {
        if let currentSections = pickSections[pickType.rawValue] {
            pickSections[pickType.rawValue] = currentSections.filter {$0 != path}
            updateStartingVerse()
        } else {
            fatalError("Tried to remove from pickSections with pickType \(pickType.rawValue)")
        }
    }
    
    
    func getStartingVerse() -> [String] {
        return startingVerse[pickType.rawValue] ?? []
    }
    
    
    func setStartingVerse(path: [String]) {
        startingVerse[pickType.rawValue] = path
        startingVerseIsSet = true
    }
        
    
    // TODO: Intelligently get first path
    func updateStartingVerse() {
        if let currentSections = pickSections[pickType.rawValue] {
            if (!pickSectionsContains(path: startingVerse[pickType.rawValue]!)) {
                startingVerseIsSet = false
            }
            
            if (!currentSections.isEmpty && !startingVerseIsSet) {
                startingVerse[pickType.rawValue] = currentSections.first!
                var node = scriptureTree.getNode(path: startingVerse[pickType.rawValue]!)!
                while (!node.children.isEmpty) {
                    node = node.children.first!
                    startingVerse[pickType.rawValue]!.append(node.name)
                }
                startingVerse[pickType.rawValue]!.append("1")
            }
        } else {
            fatalError("Tried to add to pickSections with pickType \(pickType.rawValue)")
        }
    }
    
    
    func save() {
        let startDate = Date(timeIntervalSinceNow: Double(SECONDS_IN_DAY))
        startDateComponents = makeComponents(date: startDate)
        UserDefaults.standard.set(pickRandom, forKey: "pickRandom")
        UserDefaults.standard.set(pickType.rawValue, forKey: "pickType")
        UserDefaults.standard.set(pickSections, forKey: "pickSections")
        UserDefaults.standard.set(startingVerse, forKey: "startingVerse")
        UserDefaults.standard.set(startDate, forKey: "startDate")
        UserDefaults.standard.set(themeColor.color.rawValue, forKey: "themeColor")
    }
    
    
    func reset() {
        pickRandom = UserDefaults.standard.bool(forKey: "pickRandom")
        pickType = PickType(rawValue: UserDefaults.standard.string(forKey: "pickType") ?? "Chapters") ?? .chapters
        pickSections = UserDefaults.standard.object(forKey: "pickSections") as? Dictionary<String, [[String]]> ??
            ["Volumes": [], "Books": [], "Chapters": [], "Topical Guide": []]
        startingVerse[pickType.rawValue] = UserDefaults.standard.object(forKey: "startingVerse") as? [String] ??
            ["Scriptures", "Book of Mormon", "1 Nephi", "1 Nephi 1", "1"]
        
        let startDate = UserDefaults.standard.object(forKey: "startDate") as? Date ?? Date()
        self.startDateComponents = makeComponents(date: startDate)
        startingVerseIsSet = false
        
        themeColor = ThemeColor(color: ThemeColorOptions(rawValue: UserDefaults.standard.string(forKey: "themeColor") ?? "blue") ?? .blue)
    }
    
    
    /**
     Determines if one path contains the other or vice versa.
     */
    private func pathsAlign(_ path1: [String], _ path2: [String]) -> Bool {
        let minCount = path1.count < path2.count ? path1.count : path2.count
        return path1[0..<minCount] == path2[0..<minCount]
    }
}


enum PickType: String, CaseIterable, Hashable {
    case all = "All Scriptures"
    case volumes = "Volumes"
    case books = "Books"
    case chapters = "Chapters"
    case topicalGuide = "Topical Guide"
}
