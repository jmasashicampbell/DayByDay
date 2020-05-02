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
        VStack(alignment: .leading) {
            HStack {
                Text(String(format:"%f", scripture.date))
                    .font(.headline)
            }
            
            Text(scripture.text)
            Text(scripture.reference)
            
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("Share")
                    }.padding(5)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("View in Gospel Library")
                    }.padding(5)
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

struct ScriptureDetail_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureDetail(scripture: scriptureData[0])
    }
}
