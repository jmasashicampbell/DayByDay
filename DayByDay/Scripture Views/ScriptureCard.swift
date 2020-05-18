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

struct ScriptureCard: View {
    var scripture: Scripture
    @Binding var scriptureSelected: Bool
    @Binding var selectedScripture: Scripture?
    
    var body: some View {
        Button(action: {
            self.selectedScripture = self.scripture
            self.scriptureSelected.toggle()
        } ) {
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text(dateComponentsToString(self.scripture.date, format: "E"))
                    .font(REG_BIG_FONT)
                    
                    Text(dateComponentsToString(self.scripture.date, format: "MMM dd"))
                    .font(MED_BIG_FONT)
                }
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                Text(scripture.text)
                    .font(LIGHT_FONT)
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                Text(scripture.reference)
                Spacer()
                
                VStack {
                    HStack {
                        Text(scripture.notes)
                            .font(SMALL_FONT)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(10)
                .frame(height: 210)
                .background(THEME_COLOR_LIGHT)
                .cornerRadius(10)
            }
            .padding(0)
            .font(MED_FONT)
            .foregroundColor(TEXT_COLOR)
        }
        .padding(20)
        .background(THEME_COLOR)
        .cornerRadius(25)
    }
}

/*struct ScriptureCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureCard(scripture: previewContent.generatedScriptures.array[0])
            ScriptureCard(scripture: previewContent.generatedScriptures.array[1])
        }
        .previewLayout(.fixed(width: 330, height: 640))
    }
}*/
