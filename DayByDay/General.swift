//
//  General.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/9/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: Functions

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


func makeComponents(date: Date) -> DateComponents {
    return Calendar.current.dateComponents([.year, .month, .day], from: date)
}


// MARK: Extensions

extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: 1, y: -1, anchor: .center)
    }
}

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year! < rhs.year!
        } else if lhs.month! != rhs.month! {
            return lhs.month! < rhs.month!
        } else {
            return lhs.day! < rhs.day!
        }
    }
}


// MARK: Styles

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
            Spacer()
            Button(action: { withAnimation {
                configuration.isOn.toggle()
                }
            } ) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
    }
}
