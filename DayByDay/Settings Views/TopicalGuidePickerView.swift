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
    
    var body: some View {
        Form {
            List {
                ForEach(ALPHABET, id: \.self) { letter in
                    NavigationLink(destination: TopicalGuideLetterView(letter: letter)) {
                        HStack {
                            Text(letter)
                            Spacer()
                            if self.countSelectedTitlesFor(letter: letter, settings: self.settings) > 0 {
                                Text(String(self.countSelectedTitlesFor(letter: letter, settings: self.settings)))
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Topical Guide")
    }
    
    private func countSelectedTitlesFor(letter: String, settings: Settings) -> Int {
        let titles = settings.pickSections[settings.pickType.rawValue]!
        return titles.filter { $0.first!.first!.uppercased() == letter }.count
    }

}

struct TopicalGuideLetterView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    var letter: String
    
    var body: some View {
        let textColor = colorScheme == .dark ? Color.white : Color.black
        let accentColor = self.settings.themeColor.dark()
        let allTitles = Array(topicalGuideDict.keys).sorted()
        let titles = allTitles.filter { $0.first!.uppercased() == letter }
        
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
        .navigationBarTitle(letter)
    }
}


struct TopicalGuidePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TopicalGuidePickerView()
        .environmentObject(Settings())
    }
}
