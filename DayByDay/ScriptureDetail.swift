//
//  ScriptureDetail.swift
//  DayByDay
//
//  Created by Jerome Campbell on 4/30/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI
import CoreGraphics

let BUTTON_SPACE_HEIGHT : CGFloat = 20.0
let EXPANSION_HEIGHT : CGFloat = 40.0

struct ScriptureDetail: View {
    var scripture: Scripture
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                ScriptureView(scripture: self.scripture)
                Spacer().frame(height: BUTTON_SPACE_HEIGHT)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                Spacer().frame(height: BUTTON_SPACE_HEIGHT)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "book")
                    Text("View in Gospel Library")
                }
                Spacer().frame(height: BUTTON_SPACE_HEIGHT)
            }
            // Expand view to overlap stupid huge navigation bar
            .frame(height: geometry.size.height + EXPANSION_HEIGHT)
            .padding()
            .font(SMALL_FONT)
            .foregroundColor(TEXT_COLOR)
            .background(THEME_COLOR)
            .cornerRadius(20)
        }
        // Offset to account for extra size
        .offset(y: -EXPANSION_HEIGHT / 2)
        .padding()
    }
}

struct ScriptureDetail_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureDetail(scripture: generatedScriptureData[0])
    }
}
