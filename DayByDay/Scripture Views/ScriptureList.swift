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
    @EnvironmentObject var viewRouter: ViewRouter
    @State var openInEdit = false
    //var navBarHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            Spacer().frame(width: 10)
                            ForEach(self.generatedScriptures.getPast().reversed()) { scripture in
                                VStack {
                                    Spacer()
                                    ScriptureCard(scripture: scripture,
                                                  scriptureSelected: self.$selectionCoordinator.selected,
                                                  selectedScripture: self.$selectionCoordinator.scripture,
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
            }
            //.accentColor(settings.themeColor.dark)
            .opacity(self.selectionCoordinator.selected ? 0.0 : 1.0)
            .animation(Animation.easeInOut.speed(0.7))
            
            if (self.selectionCoordinator.selected) {
                ScriptureDetail(scripture: self.selectionCoordinator.scripture!,
                                scriptureSelected: self.$selectionCoordinator.selected,
                                openInEdit: self.$openInEdit)
                    //.shadow(Color(red: 0.9, green: 0.9, blue: 0.9), radius: 10)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(dampingFraction: 0.8))
            }
        }
        .sheet(isPresented: $viewRouter.showIntro) {
            IntroNavigator()
                .environmentObject(self.settings)
                .environmentObject(self.viewRouter)
                .environmentObject(self.generatedScriptures)
        }
        .onAppear { self.generatedScriptures.update() }
    }
}


class ViewRouter: ObservableObject {
    @Published var showIntro: Bool
    
    init() {
        showIntro = !UserDefaults.standard.bool(forKey: "didLaunchBefore")
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
            ScriptureList()
                .environmentObject(GeneratedScriptures())
                .environmentObject(Settings())
                .environmentObject(SelectionCoordinator())
                .environmentObject(ViewRouter())
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
        }
    }
}
