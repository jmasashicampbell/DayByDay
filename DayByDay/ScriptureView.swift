//
//  ScriptureView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

let SCRIPTURE_CARD_SPACING: CGFloat = 15.0
let MED_FONT : Font = .system(size: 24, weight: .medium)
let LIGHT_FONT : Font = .system(size: 24, weight: .light)
let SMALL_FONT : Font = .system(size: 20, weight: .light)

struct ScriptureView: View {
    var scripture: Scripture
    var body: some View {
        VStack(alignment: .leading, spacing: SCRIPTURE_CARD_SPACING) {
            HStack {
                Text(convertDate(date: scripture.date, format: "E"))
                Spacer()
                Text(convertDate(date: scripture.date, format: "MMM dd"))
            }
            Text(scripture.text)
                .font(LIGHT_FONT)
            Text(scripture.reference)
            Spacer()
            
            HStack {
                VStack {
                    Text(scripture.notes)
                        .font(SMALL_FONT)
                    Spacer()
                }
                .padding(10)
                Spacer()
            }
            .frame(height: 180)
            .background(THEME_COLOR_LIGHT)
            .cornerRadius(10)
            //TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: "")
            
        }
        .font(MED_FONT)
        .foregroundColor(TEXT_COLOR)
    }
}

struct ScriptureView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureView(scripture: scriptureData[0])
            ScriptureView(scripture: scriptureData[1])
        }
        .background(THEME_GRADIENT)
        .previewLayout(.fixed(width: 300, height: 600))
    }
}
