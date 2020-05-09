//
//  ScriptureMap.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/8/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


class ScriptureMap {
    let oldTestament: Dictionary<String, Dictionary<String, ChapterLimits>>
    let newTestament: Dictionary<String, Dictionary<String, ChapterLimits>>
    let bookOfMormon: Dictionary<String, Dictionary<String, ChapterLimits>>
    let doctrineAndCovenants: Dictionary<String, ChapterLimits>
    let pearlOfGreatPrice: Dictionary<String, Dictionary<String, ChapterLimits>>
    
    let volumesInOrder: [String]
    var booksInOrder: Dictionary<String, [String]>
    var chaptersInOrder: Dictionary<String, [String]>
    
    init() {
        oldTestament = load(bundleUrlFromFilename("old_testament_map.json"))
        newTestament = load(bundleUrlFromFilename("new_testament_map.json"))
        bookOfMormon = load(bundleUrlFromFilename("book_of_mormon_map.json"))
        doctrineAndCovenants = load(bundleUrlFromFilename("doctrine_and_covenants_map.json"))
        pearlOfGreatPrice = load(bundleUrlFromFilename("pearl_of_great_price.json"))
        
        volumesInOrder = ["Old Testament", "New Testament", "Book of Mormon", "Doctrine and Covenants", "Pearl of Great Price"]
    }
    
    
}

struct ChapterLimits: Codable {
    let start: Int
    let end: Int
}

