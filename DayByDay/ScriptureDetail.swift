//
//  ScriptureDetail.swift
//  DayByDay
//
//  Created by Jerome Campbell on 4/30/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct ScriptureDetail: View {
    var scripture: Scripture
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                ScriptureView(scripture: scripture)
                Spacer().frame(height: 20)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                Spacer().frame(height: 20)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "book")
                    Text("View in Gospel Library")
                }
                Spacer().frame(height: 20)
                }.font(SMALL_FONT)
            .padding()
            .foregroundColor(TEXT_COLOR)
            .background(THEME_GRADIENT)
            .cornerRadius(20)
        }
        .padding()
    }
}

struct ScriptureDetail_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureDetail(scripture: scriptureData[0])
    }
}
