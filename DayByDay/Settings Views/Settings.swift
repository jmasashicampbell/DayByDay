//
//  Settings.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import UserNotifications


class Settings: ObservableObject {
    @Published var pickRandom = UserDefaults.standard.bool(forKey: "pickRandom")
    @Published var pickType = PickType(rawValue: UserDefaults.standard.string(forKey: "pickType") ?? "All Scriptures") ?? .all
    @Published var pickSections = UserDefaults.standard.object(forKey: "pickSections") as? Dictionary<String, [[String]]> ??
        ["Volumes": [], "Books": [], "Chapters": [], "Topical Guide": []]
    @Published var tomorrowVerses = UserDefaults.standard.object(forKey: "tomorrowVerses") as? Dictionary<String, [String]> ??
        ["Volumes": BOM_FIRST_VERSE, "Books": BOM_FIRST_VERSE, "Chapters": BOM_FIRST_VERSE, "Topical Guide": BOM_FIRST_VERSE]
    private var tomorrowVerseIsSet = true
    var shouldUpdateTomorrowVerse = true
         
    var startingVerse = UserDefaults.standard.object(forKey: "startingVerse") as? [String] ?? BOM_FIRST_VERSE
    var startDateComponents: DateComponents
    
    @Published var notificationsOn = UserDefaults.standard.bool(forKey: "notificationsOn")
    @Published var notificationsTime = UserDefaults.standard.object(forKey: "notificationsTime") as? Date ?? Date()
    @Published var themeColor = ThemeColor(color: ThemeColorOptions(rawValue: UserDefaults.standard.string(forKey: "themeColor") ?? "blue") ?? .blue)
    
    
    init() {
        let startDate = UserDefaults.standard.object(forKey: "startDate") as? Date ?? Date()
        self.startDateComponents = makeComponents(date: startDate)
        updateTomorrowVerse()
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
            checkTomorrowVerseValid()
        } else {
            fatalError("Tried to add to pickSections with pickType \(pickType.rawValue)")
        }
    }
    
    
    func removePickSection(path: [String]) {
        if let currentSections = pickSections[pickType.rawValue] {
            pickSections[pickType.rawValue] = currentSections.filter {$0 != path}
            checkTomorrowVerseValid()
        } else {
            fatalError("Tried to remove from pickSections with pickType \(pickType.rawValue)")
        }
    }
    
    
    func getTomorrowVerse() -> [String] {
        return tomorrowVerses[pickType.rawValue] ?? []
    }
    
    
    func setTomorrowVerse(path: [String]) {
        tomorrowVerses[pickType.rawValue] = path
        tomorrowVerseIsSet = true
    }
        
    
    func checkTomorrowVerseValid() {
        if let currentSections = pickSections[pickType.rawValue] {
            if (!pickSectionsContains(path: tomorrowVerses[pickType.rawValue]!)) {
                tomorrowVerseIsSet = false
            }
            
            if (!currentSections.isEmpty && !tomorrowVerseIsSet) {
                tomorrowVerses[pickType.rawValue] = currentSections.first!
                var node = scriptureTree.getNode(path: tomorrowVerses[pickType.rawValue]!)!
                while (!node.children.isEmpty) {
                    node = node.children.first!
                    tomorrowVerses[pickType.rawValue]!.append(node.name)
                }
                tomorrowVerses[pickType.rawValue]!.append("1")
            }
        } else {
            fatalError("Tried to add to pickSections with pickType \(pickType.rawValue)")
        }
    }
    
    
    func updateTomorrowVerse() {
        if (shouldUpdateTomorrowVerse) {
            if let tomorrowScripture = GeneratedScriptures().getFuture().first {
                tomorrowVerses[pickType.rawValue] = pathFrom(index: tomorrowScripture.index)
                shouldUpdateTomorrowVerse = false
            }
        }
    }
    
    
    func save() {
        UserDefaults.standard.set(pickRandom, forKey: "pickRandom")
        UserDefaults.standard.set(pickType.rawValue, forKey: "pickType")
        UserDefaults.standard.set(pickSections, forKey: "pickSections")
        UserDefaults.standard.set(tomorrowVerses, forKey: "tomorrowVerses")
        
        UserDefaults.standard.set(tomorrowVerses[pickType.rawValue], forKey: "startingVerse")
        let startDate = Date(timeIntervalSinceNow: Double(SECONDS_IN_DAY))
        startDateComponents = makeComponents(date: startDate)
        UserDefaults.standard.set(startDate, forKey: "startDate")
        
        
        UserDefaults.standard.set(notificationsOn, forKey: "notificationsOn")
        UserDefaults.standard.set(notificationsTime, forKey: "notificationsTime")
        UserDefaults.standard.set(themeColor.color.rawValue, forKey: "themeColor")
        
        shouldUpdateTomorrowVerse = true
    }
    
    
    func reset() {
        pickRandom = UserDefaults.standard.bool(forKey: "pickRandom")
        pickType = PickType(rawValue: UserDefaults.standard.string(forKey: "pickType") ?? "Chapters") ?? .chapters
        pickSections = UserDefaults.standard.object(forKey: "pickSections") as? Dictionary<String, [[String]]> ??
            ["Volumes": [], "Books": [], "Chapters": [], "Topical Guide": []]
        tomorrowVerses = UserDefaults.standard.object(forKey: "tomorrowVerses") as? Dictionary<String, [String]> ??
            ["Volumes": BOM_FIRST_VERSE, "Books": BOM_FIRST_VERSE, "Chapters": BOM_FIRST_VERSE, "Topical Guide": BOM_FIRST_VERSE]
        tomorrowVerseIsSet = false
        
        startingVerse = UserDefaults.standard.object(forKey: "startingVerse") as? [String] ?? BOM_FIRST_VERSE
        let startDate = UserDefaults.standard.object(forKey: "startDate") as? Date ?? Date()
        startDateComponents = makeComponents(date: startDate)
        
        notificationsOn = UserDefaults.standard.bool(forKey: "notificationsOn")
        notificationsTime = UserDefaults.standard.object(forKey: "notificationsTime") as? Date ?? Date()
        themeColor = ThemeColor(color: ThemeColorOptions(rawValue: UserDefaults.standard.string(forKey: "themeColor") ?? "blue") ?? .blue)
        
        shouldUpdateTomorrowVerse = true
    }
    
    
    private func askNotifications() {
        if (notificationsOn) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Notifications enabled")
                } else {
                    self.notificationsOn = false
                }
            }
        }
    }
    
    
    /**
     Determines if one path contains the other or vice versa.
     */
    private func pathsAlign(_ path1: [String], _ path2: [String]) -> Bool {
        let minCount = path1.count < path2.count ? path1.count : path2.count
        return path1[0..<minCount] == path2[0..<minCount]
    }
    
    private func pathFrom(index: Int) -> [String] {
        var node = scriptureTree.root
        while (!node.children.isEmpty) {
            for child in node.children {
                if (child.end > index) {
                    node = child
                    break
                }
            }
        }
        return node.path + [String(index - node.start + 1)]
    }
}


enum PickType: String, CaseIterable, Hashable {
    case all = "All Scriptures"
    case volumes = "Volumes"
    case books = "Books"
    case chapters = "Chapters"
    case topicalGuide = "Topical Guide"
}
