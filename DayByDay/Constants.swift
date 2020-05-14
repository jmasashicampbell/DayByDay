//
//  Constants.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/2/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI

let TEXT_COLOR = Color.white
let THEME_COLOR = Color(red: 0.0, green: 0.6, blue: 0.95)
let THEME_COLOR_LIGHT = Color(red: 0.09, green: 0.66, blue: 0.98)
let THEME_COLOR_DARK = Color(red: 0.0, green: 0.51, blue: 0.81)
let THEME_GRADIENT = LinearGradient(
                         gradient: Gradient(colors: [THEME_COLOR, THEME_COLOR_DARK]),
                         startPoint: .top,
                         endPoint: .bottom
                     )


let MED_FONT : Font = .system(size: 22, weight: .medium)
let LIGHT_FONT : Font = .system(size: 22, weight: .light)
let SMALL_FONT : Font = .system(size: 18, weight: .light)

let SECONDS_IN_DAY = 86400
