//
//  WidgetFonts.swift
//  ScriptureWidgetExtension
//
//  Created by Jerome Campbell on 4/3/22.
//  Copyright © 2022 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI

fileprivate let SMALL_TITLE_SIZE: CGFloat = 16
fileprivate let SMALL_TEXT_SIZE: CGFloat  = 14
fileprivate let MED_TITLE_SIZE: CGFloat  = 18
fileprivate let MED_TEXT_SIZE: CGFloat  = 14
fileprivate let LARGE_TITLE_SIZE: CGFloat  = 20
fileprivate let LARGE_TEXT_SIZE: CGFloat  = 18


enum WidgetFonts {
    case small
    case medium
    case large
    
    private var titleSize: CGFloat {
        switch self {
        case .small:
            return SMALL_TITLE_SIZE
        case .medium:
            return MED_TITLE_SIZE
        case .large:
            return LARGE_TITLE_SIZE
        }
    }
    
    private var textSize: CGFloat {
        switch self {
        case .small:
            return SMALL_TEXT_SIZE
        case .medium:
            return MED_TEXT_SIZE
        case .large:
            return LARGE_TEXT_SIZE
        }
    }
    
    var weekdayFont: Font {
        return .system(size: self.titleSize, weight: .medium)
    }
    
    var dateFont: Font {
        return .system(size: self.titleSize, weight: .semibold)
    }
    
    var textFont: Font {
        return .system(size: self.textSize, weight: .light)
    }
    
    var referenceFont: Font {
        return .system(size: self.textSize, weight: .regular)
    }
}
