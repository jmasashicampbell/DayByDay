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
        
        let mode = self.colorScheme == .light ? "light" : "dark"
        
        return Form {
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
                    Toggle("", isOn: notificationsOnBinding)
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
                    Picker("pickColor", selection: themeColorBinding) {
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
        .sheet(isPresented: self.$presentSheet) {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: { self.presentSheet = false } ) {
                        Image(systemName: "chevron.down")
                    }
                }
                
                Text("To enable notifications, turn on notifications for Day By Day in your phone's settings.")
                
                GeometryReader { geometry in
                    Image("settings1_" + mode)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
                
                GeometryReader { geometry in
                    Image("settings2_" + mode)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                }
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }) {
                    Text("Go to Settings")
                    Image(systemName: "chevron.right")
                }
                Spacer().frame(height: 5)
            }
            .padding(20)
            .foregroundColor(self.settings.themeColor.text())
            .background(self.settings.themeColor.main())
            .font(SEMIBOLD_BIG_FONT)
            .edgesIgnoringSafeArea(.all)
        }
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
