//
//  LandmarkLists.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/2/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct ScriptureList: View {
    @EnvironmentObject var generatedScriptures: GeneratedScriptures
    init() {
        //UINavigationBar.appearance().backgroundColor = .yellow
    }
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        Spacer().frame(width: 10)
                        ForEach(self.generatedScriptures.getPast().reversed()) { scripture in
                            NavigationLink(destination: ScriptureDetail(scripture: scripture)
                            ) {
                                ScriptureCard(scripture: scripture)
                                    .flip()
                                    .frame(width: geometry.size.width - 74,
                                           height: geometry.size.height - 82)
                            }
                        }
                        Spacer().frame(width: 10)
                    }
                }
                .flip()
                .navigationBarItems(
                    leading:
                        Button(action: {
                            print(geometry.size.height)
                        }) {
                            Image(systemName: "info.circle")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(THEME_COLOR)
                        },
                    trailing:
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(THEME_COLOR)
                        }
                )
            }
        }
        .onAppear { self.generatedScriptures.update() }
    }
}

struct ScriptureList_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureList()
    }
}
