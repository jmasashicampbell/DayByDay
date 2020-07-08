//
//  CircleScale.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

let START_DEGREES: Double = 130
let END_DEGREES: Double = 50
let DIFFERENCE_DEGREES: Double = (END_DEGREES - START_DEGREES + 360.0).truncatingRemainder(dividingBy: 360)

struct CircleScale: View {
    var verses: Int
    var maxVerses: Int
    var lineWidth: CGFloat
    var accentColor: Color
    
    var body: some View {
        let fraction = Double(verses) / Double(maxVerses)
        let percentage = round(fraction * 10000) / 100.0
        
        return GeometryReader { g in
            ZStack {
                RoundedArc(geometry: g,
                           lineWidth: min(g.size.height, g.size.width) * 0.08,
                           fraction: 1.0,
                           color: Color(red: 0.9, green: 0.9, blue: 0.9))
                
                RoundedArc(geometry: g,
                           lineWidth: min(g.size.height, g.size.width) * 0.08,
                           fraction: fraction,
                           color: self.accentColor)
                
                Text(String(percentage) + "%")
                    .font(.system(size: min(g.size.height, g.size.width) * 0.22 - 1, weight: .medium))
                    .offset(y: min(g.size.height, g.size.width) * -0.03)
                
                Text(String(self.verses) + " / " + String(self.maxVerses))
                    .font(.system(size: min(g.size.height, g.size.width) * 0.05 + 8, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .offset(y: min(g.size.height, g.size.width) * 0.15)
            }
        }
    }
}

struct RoundedArc: View {
    var geometry: GeometryProxy
    var lineWidth: CGFloat
    var fraction: Double
    var color: Color
    
    var body: some View {
        let radius = (min(geometry.size.height, geometry.size.width) - lineWidth) / 2
        let startAngle = Angle.degrees(START_DEGREES)
        let startPoint = CGPoint(x: CGFloat(cos(startAngle.radians)) * radius,
                                 y: CGFloat(sin(startAngle.radians)) * radius)
        
        let endAngle = Angle.degrees((DIFFERENCE_DEGREES * fraction + START_DEGREES).truncatingRemainder(dividingBy: 360.0))
        let endPoint = CGPoint(x: CGFloat(cos(endAngle.radians)) * radius,
                               y: CGFloat(sin(endAngle.radians)) * radius)
        
        return ZStack {
            Arc(radius: radius, lineWidth: lineWidth, fraction: fraction)
                .fill(color)
            
            Circle()
                .fill(color)
                .frame(width: lineWidth, height: lineWidth)
                .offset(x: startPoint.x, y: startPoint.y)
            
            Circle()
                .fill(color)
                .frame(width: lineWidth, height: lineWidth)
                .offset(x: endPoint.x, y: endPoint.y)
        }
    }
}

struct Arc: Shape {
    var radius: CGFloat
    var lineWidth: CGFloat
    var fraction: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let endAngle = (
            DIFFERENCE_DEGREES * fraction + START_DEGREES).truncatingRemainder(dividingBy: 360.0)
        
        var p = Path()
        p.addArc(center: center, radius: radius, startAngle: .degrees(START_DEGREES), endAngle: .degrees(endAngle), clockwise: false)

        return p.strokedPath(.init(lineWidth: lineWidth))
    }
}


struct CircleScale_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircleScale(verses: 11216,
                             maxVerses: 27318,
                             lineWidth: 30,
                             accentColor: .green)
            HStack(spacing: 20) {
                CircleScale(verses: 11216,
                                 maxVerses: 27318,
                                 lineWidth: 30,
                                 accentColor: .green)
                CircleScale(verses: 11216,
                                 maxVerses: 27318,
                                 lineWidth: 30,
                                 accentColor: .green)
            }
        }
        .padding(20)
    }
}
