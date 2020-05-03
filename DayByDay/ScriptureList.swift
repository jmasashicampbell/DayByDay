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
                HStack(alignment: .top, spacing: 0) {
                    ForEach(scriptureData) { scripture in
                        NavigationLink(destination: ScriptureDetail(scripture: scripture)) {
                            ScriptureRow(scripture: scripture)
                                .frame(width: 200.0,
                                       height: 200.0
                                )
                        }
                    }
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
