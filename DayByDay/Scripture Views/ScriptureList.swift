//
//  LandmarkLists.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/2/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI


struct ScriptureList: View {
    @EnvironmentObject var generatedScriptures: GeneratedScriptures
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var selectionCoordinator: SelectionCoordinator
    @State var openInEdit = false
    //var navBarHeight: CGFloat = 0
    
    var body: some View {
        let sheetBinding = Binding(
            get: { return selectionCoordinator.scripture != nil },
            set: { selectionCoordinator.scripture = $0 ? nil : nil })
        
        return NavigationView {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        Spacer().frame(width: 10)
                        ForEach(self.generatedScriptures.getPast().reversed()) { scripture in
                            VStack {
                                Spacer()
                                ScriptureCard(scripture: scripture,
                                              openInEdit: self.$openInEdit,
                                              height: geometry.size.height)
                                .flip()
                                .frame(width: geometry.size.width - 74,
                                       height: geometry.size.height * 0.9)
                                .animation(nil)
                                //.shadow(color: self.settings.themeColor.color == ThemeColorOptions.white ? Color(red: 0.92, green: 0.92, blue: 0.92) : Color.white, radius: 10)
                                Spacer()
                            }
                        }
                        Spacer().frame(width: 10)
                    }
                }
                .flip()
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        NavigationLink(destination: DashboardView()) {
                            Image(systemName: "gauge")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(self.settings.themeColor.dark)
                        },
                    trailing:
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(self.settings.themeColor.dark)
                        }
                )
            }
            .sheet(isPresented: sheetBinding) {
                ScriptureDetail(openInEdit: self.$openInEdit,
                                notes: self.selectionCoordinator.scripture!.notes)
                    .environmentObject(settings)
                    .environmentObject(generatedScriptures)
                    .environmentObject(selectionCoordinator)
                    //.shadow(Color(red: 0.9, green: 0.9, blue: 0.9), radius: 10)
            }
        }
        .onAppear { self.generatedScriptures.update() }
    }
}




struct ScriptureList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureList()
                .environmentObject(GeneratedScriptures())
                .environmentObject(Settings())
                .environmentObject(SelectionCoordinator())
                .environmentObject(ViewRouter())
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd Generation)"))
            /*ScriptureList()
                .environmentObject(GeneratedScriptures())
                .environmentObject(Settings())
                .environmentObject(SelectionCoordinator())
                .environmentObject(ViewRouter())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))*/
        }
    }
}
