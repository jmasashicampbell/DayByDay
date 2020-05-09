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
                        //.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    if (pickType != PickType.all) {
                        Picker(pickType.rawValue, selection: $pickType) {
                            ForEach(PickType.allCases, id: \.self) { pickType in
                                Text(pickType.rawValue).tag(pickType)
                            }
                        }
                    }
                }
            }.padding(5)
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
