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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var entries: [[String]]
    @State var selectedVerse: [String]
    
    var body: some View {
        Form {
            List {
                ForEach(entries, id: \.self[0]) { entry in
                    NavigationLink(destination: TGEntryPickerView(entry: entry[0], selectedVerse: $selectedVerse)) {
                        Text(entry[0])
                    }
                }
            }
        }
        .navigationBarItems(
            leading:
                Button(action: {
                    settings.setTomorrowVerse(path: selectedVerse)
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
        .navigationBarTitle("Entries")
    }
}

struct TGEntryPickerView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var entry: String
    @Binding var selectedVerse: [String]
    
    var body: some View {
        let verseIndices = topicalGuideDict[entry]!
        let verses = verseIndices.map { scriptureTree.getPath(index: $0) }
        return Form {
            List {
                ForEach(verses, id: \.self) { verse in
                    Button(action: { selectedVerse = verse }) {
                        SelectionRow(verse: verse, selectedVerse: selectedVerse)
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
                        Text("Entries")
                    }
                    .foregroundColor(settings.themeColor.dark)
                }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(entry)
    }
    
    struct SelectionRow: View {
        @EnvironmentObject var settings: Settings
        @Environment(\.colorScheme) var colorScheme
        var verse: [String]
        var selectedVerse: [String]
        
        var body: some View {
            let textColor = colorScheme == .dark ? Color.white : Color.black
            let accentColor = self.settings.themeColor.dark
            let selected = selectedVerse == verse
            
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
