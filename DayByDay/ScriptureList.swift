//
//  LandmarkLists.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/2/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct ScriptureList: View {
    init() {
        //UINavigationBar.appearance().backgroundColor = .yellow
    }
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        Spacer().frame(width: 10)
                        ForEach(generatedScriptures) { scripture in
                            NavigationLink(destination: ScriptureDetail(scripture: scripture)
                            //navigationBarHidden(true)
                            ) {
                                ScriptureCard(scripture: scripture)
                                    .frame(width: geometry.size.width - 74,
                                           height: 640.0)
                            }
                        }
                        Spacer().frame(width: 10)
                    }
                }
                .navigationBarItems(
                    leading:
                        Button(action: {generateScripture()}) {
                            Image(systemName: "info.circle")
                        },
                    trailing:
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                        }
                )
                .imageScale(.large)
                .foregroundColor(THEME_COLOR)
            }
        }
    }
}

struct ScriptureList_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureList()
    }
}
