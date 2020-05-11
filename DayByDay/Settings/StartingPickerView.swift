//
//  StartingPickerView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/11/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct StartingPickerView: View {
    @EnvironmentObject var settings: Settings
    var volumeNode = scriptureTree.root.getChild(name: settings.startingVerse.volume)
    
    var body: some View {
        HStack {
            Picker("Pick from", selection: $settings.startingVerse.volume) {
                ForEach(scriptureTree.root.children
                    .filter({ self.settings.referencesContains(path: $0.path) }),
                    id: \.start) { volume in
                    Text(volume.name).tag(volume.name)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 180)
            
            if (settings.startingVerse.volume == "Doctrine and Covenants") {
                Picker("Pick from", selection: $settings.startingVerse.book) {
                    ForEach(scriptureTree.root.children
                        .filter({ self.settings.referencesContains(path: $0.path) }),
                        id: \.start) { volume in
                        Text(volume.name).tag(volume.name)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 180)
            }
            
            /*Picker("Pick from", selection: $settings.startingVerse.chapter) {
                ForEach(scriptureTree.root.children
                    .filter({ self.settings.referencesContains(path: $0.path) }),
                    id: \.start) { volume in
                    Text(volume.name).tag(volume.name)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 180)
            
            Picker("Pick from", selection: $settings.startingVerse.verse) {
                ForEach(scriptureTree.root.children
                    .filter({ self.settings.referencesContains(path: $0.path) }),
                    id: \.start) { volume in
                    Text(volume.name).tag(volume.name)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 180)*/
        }
    }
}

struct StartingPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StartingPickerView()
    }
}
