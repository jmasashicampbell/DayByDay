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
                HStack(spacing: 25) {
                    Spacer().frame(width: 25)
                    ForEach(scriptureData) { scripture in
                        NavigationLink(destination: ScriptureDetail(scripture: scripture)) {
                            ScriptureCard(scripture: scripture)
                                .frame(width: 320.0,
                                       height: 540.0
                                )
                        }
                    }
                    Spacer().frame(width: 20)
                }
            }
            .navigationBarItems(
                leading:
                    Button(action: {
                        print("Help tapped!")
                    }) {
                        Image(systemName: "info.circle")
                    },
                trailing:
                    Button(action: {
                        print("Help tapped!")
                    }) {
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
