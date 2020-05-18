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
    @State var scriptureSelected: Bool = false
    @State var selectedScripture: Scripture? = nil
    //var navBarHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            Spacer().frame(width: 10)
                            ForEach(self.generatedScriptures.getPast().reversed()) { scripture in
                                ScriptureCard(scripture: scripture,
                                              scriptureSelected: self.$scriptureSelected,
                                              selectedScripture: self.$selectedScripture)
                                .flip()
                                .frame(width: geometry.size.width - 74,
                                       height: geometry.size.height - 82)
                                .animation(nil)
                            }
                            Spacer().frame(width: 10)
                        }
                    }
                    .flip()
                    .navigationBarItems(
                        leading:
                            Button(action: {
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
            .opacity(self.scriptureSelected ? 0.0 : 1.0)
            .animation(Animation.easeInOut.speed(0.7))
            
            if (self.scriptureSelected) {
                ScriptureDetail(scripture: self.selectedScripture!, scriptureSelected: self.$scriptureSelected)
                .transition(.move(edge: .bottom))
                .animation(.spring(dampingFraction: 0.8))
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
