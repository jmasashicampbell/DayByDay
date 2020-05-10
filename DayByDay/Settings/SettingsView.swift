//
//  SettingsView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var pickRandom = UserDefaults.standard.bool(forKey: "pickRandom")
    @State private var pickType = UserDefaults.standard.object(forKey: "pickType") as? PickType ?? PickType.chapters
    var body: some View {
        Form {
            List {
                Section {
                    Picker("pickRandom", selection: $pickRandom) {
                        Text("In Order").tag(true)
                        Text("Random").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Picker("Pick from", selection: $pickType) {
                            ForEach(PickType.allCases, id: \.self) { pickType in
                                Text(pickType.rawValue).tag(pickType)
                            }
                        }
                    }
                    
                    if (pickType != PickType.all) {
                        NavigationLink(destination:
                            SettingsPickerView(node: scriptureTree.root,
                                               depth: 1,
                                               maxDepth: maxDepthMap[pickType] ?? 3)
                        ) {
                            Text(pickType.rawValue)
                        }
                    }
                }
            }.padding(5)
        }
    }
}

let maxDepthMap = [PickType.volumes: 1,
                   PickType.books: 2,
                   PickType.chapters: 3]

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
