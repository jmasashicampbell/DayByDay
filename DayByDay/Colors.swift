//
//  Colors.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/19/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI


struct ThemeColor {
    var colorSets: [ThemeColorOptions: ThemeColorSet] = [
        .brown: ThemeColorSet(r: 0.55, g: 0.35, b: 0.25, light: 0.16),
        .green: ThemeColorSet(r: 0.2, g: 0.55, b: 0.2, light: 0.2),
        .slate: ThemeColorSet(r: 0.32, g: 0.46, b: 0.58, light: 0.1),
        .blue: ThemeColorSet(r: 0.1, g: 0.53, b: 0.75, light: 0.1),
        .gray: ThemeColorSet(r: 0.35, g: 0.35, b: 0.35, light: 0.2),
        .white: ThemeColorSet(r: 1.0, g: 1.0, b: 1.0, light: 0.4)
    ]
}


enum ThemeColorOptions: Int, CaseIterable {
    case brown = 0
    case green = 1
    case slate = 2
    case blue = 3
    case gray = 4
    case white = 5
}


struct ThemeColorSet {
    let main: Color
    let light: Color
    
    init(r: Double, g: Double, b: Double, light: Double) {
        func lighten(_ value: Double) -> Double {
            return (1.0 - light) * value + light
        }
        
        self.main = Color(red: r, green: g, blue: b)
        self.light = Color(red: lighten(r), green: lighten(g), blue: lighten(b))
    }
}


var tabColors: [TabColorOptions: Color] = [
    .red: Color(red: 0.9, green: 0.3, blue: 0.23),
    .orange: Color(red: 0.98, green: 0.52, blue: 0.17),
    .yellow: Color(red: 0.95, green: 0.8, blue: 0.0),
    .green: Color(red: 0.15, green: 0.75, blue: 0.2),
    .blue: Color(red: 0.0, green: 0.73, blue: 0.88),
    .purple: Color(red: 0.6, green: 0.37, blue: 0.88),
    .pink: Color(red: 1.0, green: 0.4, blue: 0.5),
    .gray: Color(red: 0.4, green: 0.4, blue: 0.4)
]


enum TabColorOptions {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case gray
}


struct TabColorView: View {
    var color: Color
    
    var body: some View {
        Circle()
        .fill(color)
        .frame(width: 20, height: 20)
    }
}
