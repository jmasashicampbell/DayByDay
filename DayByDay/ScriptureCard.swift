//
//  ScriptureCard.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI
import CoreGraphics

let SCRIPTURE_CARD_SPACING: CGFloat = 10.0
let darkerBlue = Color(red: 0.0, green: 0.45, blue: 0.9)

struct ScriptureCard: View {
    var scripture: Scripture
    var body: some View {
        HStack(spacing: SCRIPTURE_CARD_SPACING) {
            Spacer()
            VStack(spacing: SCRIPTURE_CARD_SPACING) {
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                Text(String(format:"%f", scripture.date))
                Text(scripture.text)
                Text(scripture.reference)
                Spacer()
            }
            .font(.system(size: 24, weight: .light))
            .foregroundColor(Color.white)
            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue, darkerBlue]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
    }
}

struct ScriptureCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureCard(scripture: scriptureData[0])
            ScriptureCard(scripture: scriptureData[1])
        }
        .previewLayout(.fixed(width: 300, height: 500))
    }
}
