//
//  General.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/9/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


/**
  Converts a filename to a URL
  - Parameter filename: The filename to convert
  - Returns: The URL of the file in the main bundle
 */

func bundleUrlFromFilename(_ filename: String) -> URL {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find file in main bundle.")
    }
    return file
}


/**
  Loads a JSON object from a file
  - Parameter file: The file from which to load
  - Returns: The loaded object
 */

func load<T: Decodable>(_ file: URL) throws -> T {
    let data = try Data(contentsOf: file)
    
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse file as \(T.self):\n\(error)")
    }
}


/**
  Converts a DateComponents object to a string date representation with the provided format.
  - Parameter dateComponents: The DateComponents object to be converted
  - Parameter format: The format with which to convert
  - Returns: The converted date string
 */

func dateComponentsToString(_ dateComponents: DateComponents, format: String) -> String {
    let date = Calendar.current.date(from: dateComponents)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date!)
}

