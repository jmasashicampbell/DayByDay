//
//  TopicalGuideView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/10/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct TopicalGuidePickerView: View {
        @EnvironmentObject var settings: Settings
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            let textColor = colorScheme == .dark ? Color.white : Color.black
            let accentColor = self.settings.themeColor.dark()
            let titles = Array(topicalGuideDict.keys).sorted()
            
            return Form {
                List {
                    ForEach(titles, id: \.self) { title in
                        Button(action: {
                            if (self.settings.pickSectionsContains(path: [title])) {
                                self.settings.removePickSection(path: [title])
                            } else {
                                self.settings.addPickSection(path: [title])
                            }
                        }) {
                            HStack {
                                Text(title)
                                Spacer()
                                if (self.settings.pickSectionsContains(path: [title])) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 18, weight: .semibold))
                                        .imageScale(.medium)
                                }
                            }
                            .foregroundColor(self.settings.pickSectionsContains(path: [title]) ? accentColor : textColor)
                        }
                    }
                }
            }
            .navigationBarTitle("Topical Guide")
        }
    }

struct TopicalGuidePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TopicalGuidePickerView()
    }
}
