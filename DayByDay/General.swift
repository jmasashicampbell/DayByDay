//
//  General.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/9/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation

func bundleUrlFromFilename(_ filename: String) -> URL {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find file in main bundle.")
    }
    return file
}

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
