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
    @Environment(\.colorScheme) var colorScheme
    @State var presentSheet = false
    
    var body: some View {
        let notificationsOnBinding = Binding (
            get: { self.settings.notificationsOn },
            set: { notificationsOn in
                if (notificationsOn) {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            DispatchQueue.main.async {
                                self.settings.notificationsOn = notificationsOn
                            }
                        } else {
                            self.presentSheet = true
                        }
                    }
                } else {
                    self.settings.notificationsOn = notificationsOn
                }
        } )
    
        let themeColorBinding = Binding (
            get: { self.settings.themeColor.color },
            set: { themeColor in
                self.settings.themeColor.color = themeColor
                UIApplication.shared.setAlternateIconName(themeColor == .blue ? nil : themeColor.rawValue)
            }
        )
        
        return Form {
            // Verse selection
            Section(header: Text("VERSE SELECTION")) {
                // In order/random
                Picker("pickRandom", selection: $settings.pickRandom) {
                    Text("In Order").tag(false)
                    Text("Random").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Type picker
                NavigationLink(destination:
                    TypePickerView()
                ) {
                    HStack {
                        Text("Select from")
                        Spacer()
                        Text(self.settings.pickType.rawValue)
                    }
                }
                
                // Section picker
                if (settings.pickType != PickType.topicalGuide) {
                    NavigationLink(destination:
                        PickPickerView(node: scriptureTree.root,
                                       depth: 1,
                                       maxDepth: maxDepthMap[settings.pickType] ?? 3)
                    ) {
                        HStack {
                            Text(settings.pickType.rawValue)
                            Spacer()
                            if (self.settings.pickSectionsContains()) {
                                Text(String(self.settings.pickSectionsCount()))
                            }
                        }
                    }
                } else {
                    NavigationLink(destination:
                        TopicalGuidePickerView()
                    ) {
                        HStack {
                            Text("Topical Guide Entries")
                            Spacer()
                            if (self.settings.pickSectionsContains()) {
                                Text(String(self.settings.pickSectionsCount()))
                            }
                        }
                    }
                }
                
                // Starting verse picker
                if !settings.pickRandom && !settings.getCurrentSections().isEmpty {
                    if settings.pickType == .topicalGuide {
                        NavigationLink(destination:
                            TGStartingPickerView(entries: settings.getCurrentSections())
                        ) {
                            HStack {
                                Text("Start tomorrow at")
                                Spacer()
                                Text(self.makeReference(path: self.settings.getTomorrowVerse()))
                            }
                        }
                    } else {
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
            }
            
            // Notifications
            Section {
                // Notifications toggle
                Toggle("", isOn: notificationsOnBinding)
                    .toggleStyle(ThemeToggleStyle(label: "Notifications",
                                                  themeColor: settings.themeColor.main))
                    
                if (settings.notificationsOn) {
                    HStack {
                        Text("Time")
                        Spacer()
                        DatePicker(selection: $settings.notificationsTime, displayedComponents: .hourAndMinute) {
                            Text("Time")
                        }
                        .labelsHidden()
                        .frame(width: 100)
                        .accentColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                }

                // Badge toggle
                Toggle("", isOn: $settings.badgeNumOn)
                    .toggleStyle(ThemeToggleStyle(label: "Badge Number",
                                                  themeColor: settings.themeColor.main))
            }
            
            // Theme
            Section(header: Text("THEME")) {
                Picker("pickColor", selection: themeColorBinding) {
                    ForEach(ThemeColorOptions.allCases, id: \.self) { colorOption in
                        Image(colorOption.rawValue).tag(colorOption)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(height: 42)
            }
            
            Section {
                Button(action: {
                    if let url = URL(string: "https://jmcampbellapp.wordpress.com/contact/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Send Feedback")
                }
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: self.$presentSheet) {
            GoToSettingsSheet(presentSheet: self.$presentSheet)
        }
        .navigationBarTitle("Settings", displayMode: .large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.settings.reset()
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(settings.themeColor.dark)
                },
            
            trailing:
                Button(action: {
                    self.settings.save()
                    self.generatedScriptures.update(force: true)
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "checkmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(settings.themeColor.dark)
                }
        )
        .navigationBarBackButtonHidden(true)
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
