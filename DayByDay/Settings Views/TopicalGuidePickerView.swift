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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var titles: [[String]]
    
    var body: some View {
        Form {
            List {
                ForEach(ALPHABET, id: \.self) { letter in
                    NavigationLink(destination: TopicalGuideLetterView(letter: letter, chosenTitles: $titles)) {
                        HStack {
                            Text(letter)
                            Spacer()
                            if self.countSelectedTitlesFor(letter: letter) > 0 {
                                Text(String(self.countSelectedTitlesFor(letter: letter)))
                            }
                        }
                    }
                }
            }
        }
        .navigationBarItems(
            leading:
                Button(action: {
                    settings.updatePickSections(sections: titles)
                    self.mode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Settings")
                    }
                    .foregroundColor(settings.themeColor.dark)
                }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Topical Guide")
    }
    
    private func countSelectedTitlesFor(letter: String) -> Int {
        return titles.filter { $0.first!.first!.uppercased() == letter }.count
    }

}

struct TopicalGuideLetterView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var letter: String
    @Binding var chosenTitles: [[String]]
    
    var body: some View {
        let textColor = colorScheme == .dark ? Color.white : Color.black
        let accentColor = self.settings.themeColor.dark
        let allTitles = Array(topicalGuideDict.keys).sorted()
        let titles = allTitles.filter { $0.first!.uppercased() == letter }
        
        return Form {
            List {
                ForEach(titles, id: \.self) { title in
                    Button(action: {
                        if chosenTitles.contains([title]) {
                            chosenTitles = chosenTitles.filter{ $0 != [title] }
                        } else {
                            chosenTitles.append([title])
                        }
                    }) {
                        HStack {
                            Text(title)
                            Spacer()
                            if (chosenTitles.contains([title])) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .imageScale(.medium)
                            }
                        }
                        .foregroundColor(chosenTitles.contains([title]) ? accentColor : textColor)
                    }
                }
            }
        }
        .navigationBarItems(
            leading:
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Topical Guide")
                    }
                    .foregroundColor(settings.themeColor.dark)
                }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(letter)
    }
}


struct TopicalGuidePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TopicalGuidePickerView(titles: [])
        .environmentObject(Settings())
    }
}
