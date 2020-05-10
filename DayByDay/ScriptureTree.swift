//
//  ScriptureMap.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/8/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


//let scriptureTree = ScriptureTree()


class ScriptureTree {
    let deepVolumes: Dictionary<String, Dictionary<String, Dictionary<String, ChapterLimits>>>
    let doctrineAndCovenantsDict: Dictionary<String, ChapterLimits>
    let root: Node
    
    init() {
        deepVolumes = ["Old Testament": try! load(bundleUrlFromFilename("old_testament_map.json")),
                       "New Testament": try! load(bundleUrlFromFilename("new_testament_map.json")),
                       "Book of Mormon": try! load(bundleUrlFromFilename("book_of_mormon_map.json")),
                       "Pearl of Great Price": try! load(bundleUrlFromFilename("pearl_of_great_price_map.json"))]
        doctrineAndCovenantsDict = try! load(bundleUrlFromFilename("doctrine_and_covenants_map.json"))
        
        var volumes: [Node] = []
        for (volumeName, volumeDict) in deepVolumes {
            var books: [Node] = []
            for (bookName, bookDict) in volumeDict {
                var chapters: [Node] = []
                for (chapterName, chapterLimits) in bookDict {
                    let newChapter = Node(name: chapterName, start: chapterLimits.start, end: chapterLimits.end)
                    chapters.append(newChapter)
                }
                let newBook = Node(name: bookName, children: chapters)
                books.append(newBook)
            }
            let newVolume = Node(name: volumeName, children: books)
            volumes.append(newVolume)
        }
        
        // Doctrine and Covenants is handled differently because it has no books
        var sections: [Node] = []
        for (sectionName, sectionLimits) in doctrineAndCovenantsDict {
            let newSection = Node(name: sectionName, start: sectionLimits.start, end: sectionLimits.end)
            sections.append(newSection)
        }
        let newVolume = Node(name: "Doctrine and Covenants", children: sections)
        volumes.append(newVolume)
        
        root = Node(name: "Scriptures", children: volumes)
    }
}


class Node {
    var name: String
    var children: [Node]
    var start: Int
    var end: Int
    
    init(name: String, children: [Node]) {
        self.name = name
        if (!children.isEmpty) {
            self.children = children.sorted { $0.start < $1.start }
            self.start = self.children.first!.start
            self.end = self.children.last!.end
        } else {
            fatalError("Parent node initialized with no children.")
        }
    }
    
    init(name: String, start: Int, end: Int) {
        self.name = name
        self.start = start
        self.end = end
        self.children = []
    }
    
    func getChild(name: String) -> Node? {
        for child in children {
            if child.name == name {
                return child
            }
        }
        return nil
    }
}


struct ChapterLimits: Codable {
    let start: Int
    let end: Int
}
