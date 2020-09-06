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
    @EnvironmentObject var settings: Settings
    @Binding var scriptureSelected: Bool
    @Binding var selectedScripture: Scripture?
    @Binding var openInEdit: Bool
    var height: CGFloat
    
    var body: some View {
        Button(action: {
            self.openInEdit = false
            self.selectedScripture = self.scripture
            self.scriptureSelected.toggle()
        } ) {
            VStack(alignment: .leading, spacing: 0.0) {
                // Header
                HStack {
                    Text(dateComponentsToString(self.scripture.date, format: "E"))
                    .font(FONT_REG_BIG)
                    
                    Text(dateComponentsToString(self.scripture.date, format: "MMM dd"))
                    .font(FONT_SEMIBOLD_BIG)
                }
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                
                // Text
                Text(scripture.text)
                    .font(height > 600 ? FONT_LIGHT_PLUS : FONT_LIGHT)
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                Text(scripture.reference)
                Spacer()
                
                // Notes box
                Button(action: {
                    self.openInEdit = true
                    self.selectedScripture = self.scripture
                    self.scriptureSelected.toggle()
                }) {
                    HStack {
                        if scripture.notes.isEmpty {
                            Spacer()
                            VStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.system(size: 50, weight: .thin))
                                Spacer()
                            }
                        } else {
                            VStack {
                                Text(scripture.notes)
                                    .font(FONT_SMALL)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .padding(10)
                    .frame(height: 210)
                    .background(settings.themeColor.light)
                    .cornerRadius(10)
                }
                .buttonStyle(ScaleButtonStyle(scaleFactor: 0.9))
            }
            .padding(20)
            .font(FONT_MED)
            .foregroundColor(settings.themeColor.text)
            .background(settings.themeColor.main)
            .cornerRadius(25)
        }
        .padding(0)
        .buttonStyle(ScaleButtonStyle(scaleFactor: 0.96))
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
