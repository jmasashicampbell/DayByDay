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
    
    var body: some View {
        Button(action: {
            self.openInEdit = false
            self.selectedScripture = self.scripture
            self.scriptureSelected.toggle()
        } ) {
            VStack(alignment: .leading, spacing: 0.0) {
                HStack {
                    Text(dateComponentsToString(self.scripture.date, format: "E"))
                    .font(REG_BIG_FONT)
                    
                    Text(dateComponentsToString(self.scripture.date, format: "MMM dd"))
                    .font(SEMIBOLD_BIG_FONT)
                }
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                Text(scripture.text)
                    .font(LIGHT_FONT)
                Spacer().frame(height: SCRIPTURE_CARD_SPACING)
                Text(scripture.reference)
                Spacer()
                
                VStack {
                    HStack {
                        Button(action: {
                            self.openInEdit = true
                            self.selectedScripture = self.scripture
                            self.scriptureSelected.toggle()
                        }) {
                            if scripture.notes.isEmpty {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "plus")
                                            .font(.system(size: 50, weight: .thin))
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            } else {
                                Text(scripture.notes)
                                    .font(SMALL_FONT)
                                Spacer()
                            }
                        }
                        .buttonStyle(ScaleButtonStyle(scaleFactor: 0.8))
                    }
                    Spacer()
                }
                .padding(10)
                .frame(height: 210)
                .background(settings.themeColor.light())
                .cornerRadius(10)
            }
            .padding(20)
            .font(MED_FONT)
            .foregroundColor(settings.themeColor.text())
            .background(settings.themeColor.main())
            .cornerRadius(25)
        }
        .padding(0)
        .buttonStyle(ScaleButtonStyle(scaleFactor: 0.95))
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
