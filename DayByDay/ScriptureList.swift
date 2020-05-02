//
//  LandmarkLists.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/2/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct ScriptureList: View {
    var body: some View {
        NavigationView {
            List(scriptureData) { scripture in
                NavigationLink(destination: ScriptureDetail(scripture: scripture)) {
                    ScriptureRow(scripture: scripture)
                        .frame(height: SCRIPTURE_ROW_HEIGHT)
                }
            }
        }
    }
}

struct ScriptureList_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureList()
    }
}
