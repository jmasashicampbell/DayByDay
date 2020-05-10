//
//  ScriptureMap.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/8/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation

/**
  Converts a filename to a URL
  - Parameter filename: The filename to convert
  - Returns: The URL of the file in the main bundle
 */

func bundleUrlFromFilename(_ filename: String) -> URL {
    print(filename)
    return NSURL.fileURL(withPath: "Scriptures Source Data/" + filename)
}


/**
  Loads a JSON object from a file
  - Parameter file: The file from which to load
  - Returns: The loaded object
 */

func load<T: Decodable>(_ file: URL) -> T {
    let data: Data
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load file:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse file as \(T.self):\n\(error)")
    }
}


class ScriptureTree {
    let deepVolumes: [String, Dictionary<String, Dictionary<String, ChapterLimits>]
    //let deepVolumes: Dictionary<String, Dictionary<String, Dictionary<String, ChapterLimits>>>
    let doctrineAndCovenantsDict: Dictionary<String, ChapterLimits>
    var volumes: [Node]
    
    init() {
        deepVolumes = [["Old Testament": load(bundleUrlFromFilename("old_testament_map.json"))],
                       ["New Testament": load(bundleUrlFromFilename("new_testament_map.json"))],
                       ["Book of Mormon": load(bundleUrlFromFilename("book_of_mormon_map.json"))],
                       ["Pearl of Great Price": load(bundleUrlFromFilename("pearl_of_great_price_map.json"))]]
        doctrineAndCovenantsDict = load(bundleUrlFromFilename("doctrine_and_covenants_map.json"))
        
        volumes = []
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
        volumes.insert(newVolume, at: 3) // Inserts Doctrine and Covenants ahead of Pearl of Great Price
    }
    
    func getVolume(_ volumeName: String) -> Node? {
        for volume in volumes {
            if (volume.name == volumeName) {
                return volume
            }
        }
        return nil
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

func printTree(scriptureTree: ScriptureTree) -> Int {
    for volume in scriptureTree.volumes {
        print(volume.name, volume.start, volume.end)
        for book in volume.children {
            print("   ", book.name, book.start, book.end)
            if (!book.children.isEmpty) {
                for chapter in book.children {
                    print("       ", chapter.name, chapter.start, chapter.end)
                }
            }
        }
    }
    return 0
}

let scriptureTree = ScriptureTree()
let printThatTree = printTree(scriptureTree: scriptureTree)
