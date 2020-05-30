//
//  SettingsView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var generatedScriptures: GeneratedScriptures
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        Form {
            List {
                Section(header: Text("VERSE SELECTION")) {
                    Picker("pickRandom", selection: $settings.pickRandom) {
                        Text("In Order").tag(false)
                        Text("Random").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    NavigationLink(destination:
                        TypePickerView()
                    ) {
                        HStack {
                            Text("Select from")
                            Spacer()
                            Text(self.settings.pickType.rawValue)
                        }
                    }
                    
                    if (settings.pickType != PickType.all) {
                        NavigationLink(destination:
                            PickPickerView(node: scriptureTree.root,
                                               depth: 1,
                                               maxDepth: maxDepthMap[settings.pickType] ?? 3)
                        ) {
                            HStack {
                                Text(settings.pickType.rawValue)
                                Spacer()
                                if (self.settings.pickSectionsContains(path: scriptureTree.root.path)) {
                                    Text(String(self.settings.pickSectionsCount(path: scriptureTree.root.path)))
                                }
                            }
                        }
                    }
                    
                    if (!settings.pickRandom && !settings.getCurrentSections().isEmpty) {
                        NavigationLink(destination:
                            StartingPickerView(node: scriptureTree.root)
                        ) {
                            HStack {
                                Text("Start tomorrow at")
                                Spacer()
                                Text(self.makeReference(path: self.settings.getTomorrowVerse()))
                            }
                        }
                    }
                }
                
                Section {
                    Toggle("", isOn: $settings.notificationsOn)
                        .toggleStyle(
                        NotificationsToggleStyle(label: "Notifications",
                                           onColor: settings.themeColor.main()))
                    
                    if (settings.notificationsOn) {
                        DatePicker(selection: $settings.notificationsTime, displayedComponents: .hourAndMinute) {
                            Text("Time")
                        }
                    }
                }
                
                
                Section(header: Text("THEME")) {
                    Picker("pickColor", selection: $settings.themeColor.color) {
                        ForEach(ThemeColorOptions.allCases, id: \.self) { colorOption in
                            Image(colorOption.rawValue).tag(colorOption)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(height: 42)
                }
            }.padding(5)
        }
        .padding(.top, 10)
        .navigationBarTitle("Settings")
        .navigationBarItems(
            
            leading:
                Button(action: {
                    self.settings.reset()
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(settings.themeColor.dark())
                },
            
            trailing:
                Button(action: {
                    self.settings.save()
                    self.generatedScriptures.update(force: true)
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "checkmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(settings.themeColor.dark())
                }
        )
        .foregroundColor(Color.black)
        .accentColor(settings.themeColor.main())
        .onAppear { self.settings.updateTomorrowVerse() }
    }
    
    private func makeReference(path: [String]) -> String {
        if (!path.isEmpty) {
            return path[path.count - 2] + ":" + path.last!
        } else {
            fatalError("Tried to make reference for empty path")
        }
    }
}

let maxDepthMap = [PickType.volumes: 1,
                   PickType.books: 2,
                   PickType.chapters: 3]

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Settings())
    }
}
