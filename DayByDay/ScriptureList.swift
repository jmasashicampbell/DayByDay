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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    Spacer().frame(width: 10)
                    ForEach(scriptureData) { scripture in
                        NavigationLink(destination: ScriptureDetail(scripture: scripture)) {
                            ScriptureCard(scripture: scripture)
                                .frame(width: 340.0,
                                       height: 640.0
                                )
                        }
                    }
                    Spacer().frame(width: 10)
                }
            }
            .navigationBarItems(
                leading:
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                    },
                trailing:
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                    }
            )
        }
    }
}

struct ScriptureList_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureList()
    }
}
