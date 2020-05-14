//
//  ScriptureCard.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI
import CoreGraphics

struct ScriptureCard: View {
    var scripture: Scripture
    var body: some View {
        HStack(spacing: SCRIPTURE_CARD_SPACING) {
            ScriptureView(scripture: scripture)
        }
        .padding(20)
        .background(THEME_COLOR)
        .cornerRadius(25)
    }
}

struct ScriptureCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureCard(scripture: previewContent.generatedScriptures.array[0])
            ScriptureCard(scripture: previewContent.generatedScriptures.array[1])
        }
        .previewLayout(.fixed(width: 330, height: 640))
    }
}