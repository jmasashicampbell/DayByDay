//
//  Colors.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/19/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI


let STARTING_THEME_COLOR = Color(red: 0.1, green: 0.53, blue: 0.75)
let STARTING_THEME_LIGHT = Color(red: 0.42, green: 0.7, blue: 0.84)

struct ThemeColor {
    var color : ThemeColorOptions
    var colorSets: [ThemeColorOptions: ThemeColorSet] = [

        .yellow: ThemeColorSet(r: 0.93,
                               g: 0.83,
                               b: 0.55,
                               light: 0.2,
                               dark: 0.2,
                               textShade: 1.0),
        
        .sage: ThemeColorSet(r: 0.69,
                             g: 0.78,
                             b: 0.64,
                             light: 0.2,
                             dark: 0.25,
                             textShade: 1.0),
        
        .green: ThemeColorSet(r: 0.3,
                              g: 0.5,
                              b: 0.3,
                              light: 0.1,
                              dark: 0.05,
                              textShade: 1.0),
        
        .blue: ThemeColorSet(r: 0.1,
                             g: 0.53,
                             b: 0.75,
                             light: 0.12,
                             dark: 0.0,
                             textShade: 1.0),
        
        .slate: ThemeColorSet(r: 0.29,
                              g: 0.41,
                              b: 0.51,
                              light: 0.1,
                              dark: 0.0,
                              textShade: 1.0),
        
        .gray: ThemeColorSet(r: 0.3,
                             g: 0.3,
                             b: 0.3,
                             light: 0.08,
                             dark: 0.0,
                             textShade: 0.85),
        
        .brown: ThemeColorSet(r: 0.38,
                              g: 0.24,
                              b: 0.18,
                              light: 0.08,
                              dark: 0.0,
                              textShade: 0.9),
        
        /*.white: ThemeColorSet(r: 1.0,
                              g: 1.0,
                              b: 1.0,
                              light: 0.4,
                              dark: 0.3,
                              textShade: 0.7)*/
    ]
    
    func main() -> Color {
        return colorSets[color]!.main
    }
    
    func light() -> Color {
        return colorSets[color]!.light
    }
    
    func dark() -> Color {
        return colorSets[color]!.dark
    }

    func text() -> Color {
        return colorSets[color]!.text
    }
}


enum ThemeColorOptions: String, CaseIterable {
    case yellow = "yellow"
    case sage = "sage"
    case green = "green"
    case blue = "blue"
    case slate = "slate"
    case gray = "gray"
    case brown = "brown"
    //case white = "white"
}


struct ThemeColorSet {
    let main: Color
    let light: Color
    let dark: Color
    let text: Color
    
    init(r: Double, g: Double, b: Double, light: Double, dark: Double, textShade: Double) {
        
        func lighten(_ value: Double) -> Double {
            return (1.0 - light) * value + light
        }
        
        func darken(_ value: Double) -> Double {
            return (1.0 - dark) * value
        }
        
        self.main = Color(red: r, green: g, blue: b)
        self.light = Color(red: lighten(r), green: lighten(g), blue: lighten(b))
        self.dark = Color(red: darken(r), green: darken(g), blue: darken(b))
        self.text = Color(red: textShade, green: textShade, blue: textShade)
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
