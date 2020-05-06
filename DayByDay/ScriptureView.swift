//
//  ScriptureView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

let SCRIPTURE_CARD_SPACING: CGFloat = 10.0

struct ScriptureView: View {
    var scripture: Scripture
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HStack {
                Text(convertDate(date: scripture.date, format: "E"))
                Spacer()
                Text(convertDate(date: scripture.date, format: "MMM dd"))
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
            //TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: "")
            
        }
        .padding(0)
        .font(MED_FONT)
        .foregroundColor(TEXT_COLOR)
    }
}

struct ScriptureView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureView(scripture: scriptureData[0])
            ScriptureView(scripture: scriptureData[2])
        }
        .background(THEME_GRADIENT)
        .previewLayout(.fixed(width: 300, height: 600))
    }
}
