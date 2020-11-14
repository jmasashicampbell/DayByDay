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
import UserNotifications


class GeneratedScriptures: ObservableObject {
    @Published var array: [Scripture]
    let NUM_FUTURE_SCRIPTURES = 60
    
    
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
    
    
    func setScriptureNotes(id: Int, notes: String) {
        for (i, scripture) in array.enumerated() {
            if (scripture.id == id) {
                array[i].notes = notes
            }
        }
        save()
    }
    
    
    /**
     Generates new Scriptures based on settings for the next NUM_FUTURE_SCRIPTURES days.
     - Parameter force: If true, generates for all future dates. If false, only generates for dates not yet generated.
     */
    func update(force: Bool = false) {
        let settings = Settings()
        
        if (force) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            array = getPast()
        }
        
        // Schedule notification for today
        if (settings.notificationsOn) {
            if let todayScripture = getPast().last {
                let badge = settings.badgeNumOn ? 1 : 0
                scheduleNotification(scripture: todayScripture, time: settings.notificationsTime, badge: badge)
            }
        }
        
        let today = makeComponents(date: Date())
        let generatedDates = array.map { $0.date }
        for (i, date) in dateRange(startDate: today, size: NUM_FUTURE_SCRIPTURES).enumerated() {
            if (!generatedDates.contains(date)) {
                let badge = settings.badgeNumOn ? i : 0
                generateScripture(date: date, settings: settings, badge: badge)
            }
        }
        save()
    }
    
    
    func generateScripture(date: DateComponents, settings: Settings, badge: Int) {
        let currentSections = settings.getCurrentSections()
        let newIndex: Int
        var versesPool: [Int] = []

        if (currentSections.isEmpty) {
            versesPool = Array(0..<scriptureArray.count)
        } else {
            if settings.pickType == .topicalGuide {
                for title in currentSections {
                    versesPool += topicalGuideDict[title[0]]!
                }
            } else {
                for path in currentSections {
                    let node = scriptureTree.getNode(path: path)!
                    versesPool += Array(node.start..<node.end)
                }
            }
        }

        if (settings.pickRandom) {
            newIndex = versesPool.randomElement()!
        } else {
            let startIndex = indexFrom(path: settings.startingVerse)
            let dateDifference = differenceInDays(date, settings.startDateComponents)
            let startIndexInPool = versesPool.firstIndex(of: startIndex)!
            newIndex = versesPool[(startIndexInPool + dateDifference) % versesPool.count]
        }
        
        let id = array.isEmpty ? 1001 : array.last!.id + 1

        let newScripture = Scripture(index: newIndex, id: id, date: date)
        array.append(newScripture)
        if (settings.notificationsOn) {
            scheduleNotification(scripture: newScripture, time: settings.notificationsTime, badge: badge)
        }
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
    
    
    private func scheduleNotification(scripture: Scripture, time: Date, badge: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Today's scripture: " + scripture.reference
        content.body = scripture.text
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: badge)
        content.userInfo = ["index": scripture.index, "id": scripture.id, "year": scripture.date.year!, "month": scripture.date.month!, "day": scripture.date.day!]
        
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        let dateComponents = scripture.date
        let dateTimeComponents = DateComponents(calendar: Calendar.current,
                                                year: dateComponents.year,
                                                month: dateComponents.month,
                                                day: dateComponents.day,
                                                hour: timeComponents.hour,
                                                minute: timeComponents.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateTimeComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(scripture.id), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

struct Scripture: Codable, Identifiable {
    var id: Int
    var date: DateComponents
    var reference: String
    var text: String
    var notes: String
    var index: Int
    
    init(index: Int, id: Int, date: DateComponents) {
        let newVerse = scriptureArray[index]
        self.id = id
        self.date = date
        self.reference = newVerse.reference
        self.text = newVerse.text
        self.notes = ""
        self.index = index
    }
}
