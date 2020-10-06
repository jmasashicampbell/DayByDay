//
//  TopicalGuideStartingPickerView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/10/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct TGStartingPickerView: View {
    @EnvironmentObject var settings: Settings
    var entries: [[String]]
    
    var body: some View {
        Form {
            List {
                ForEach(entries, id: \.self[0]) { entry in
                    NavigationLink(destination: TGEntryPickerView(entry: entry[0])) {
                        Text(entry[0])
                    }
                }
            }
        }
    }
}

struct TGEntryPickerView: View {
    @EnvironmentObject var settings: Settings
    var entry: String
    
    var body: some View {
        let verseIndices = topicalGuideDict[entry]!
        let verses = verseIndices.map { scriptureTree.getPath(index: $0) }
        return Form {
            List {
                ForEach(verses, id: \.self) { verse in
                    Button(action: { self.settings.setTomorrowVerse(path: verse) }) {
                        SelectionRow(verse: verse)
                    }
                }
            }
        }
        .navigationBarTitle(entry)
    }
    
    struct SelectionRow: View {
        var verse: [String]
        @EnvironmentObject var settings: Settings
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            let textColor = colorScheme == .dark ? Color.white : Color.black
            let accentColor = self.settings.themeColor.dark
            let selected = self.settings.getTomorrowVerse() == self.verse
            
            return HStack {
                Text(self.verse[self.verse.count - 2] + ":" + self.verse[self.verse.count - 1])
                Spacer()
                if selected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .semibold))
                        .imageScale(.medium)
                }
            }
            .foregroundColor(selected ? accentColor : textColor)
        }
    }
}


/*struct TGStartingPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TGStartingPickerView()
    }
}
*/
