//
//  IntroNavigator.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct IntroNavigator: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var pickRandom = false
    @State var pickType = PickType.all
    @State var sectionsList: [[String]] = []
    @State var notificationsOn: Bool? = nil
    @State var notificationsTime = Date()
    
    @State var page = 0
    @State var nextDisabled: Bool = false
    
    var body: some View {
        VStack {
            Group {
                if (page == 0) {
                    IntroCover()
                } else if (page == 1) {
                    TypePicker(selectedType: self.$pickType)
                } else if (page == 2) {
                    SectionPicker(pickType: self.pickType, sectionsList: self.$sectionsList, nextDisabled: self.$nextDisabled)
                } else if (page == 3) {
                    RandomPicker(pickRandom: self.$pickRandom)
                } else if (page == 4) {
                    NotificationsPicker(notificationsOn: self.$notificationsOn, notificationsTime: self.$notificationsTime, nextDisabled: self.$nextDisabled)
                }
            }
            .transition(.move(edge: .leading))
            .animation(.default)
            
            HStack {
                if (self.page != 0) {
                    Button(action: {
                        withAnimation {
                            if (self.page == 3 && self.pickType == .all) {
                                self.page -= 2
                            } else {
                                self.page -= 1
                            }
                            self.updateNextDisabled()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
                Spacer()
                if (self.page != 4) {
                    Button(action: {
                        withAnimation {
                            if (self.page == 1 && self.pickType == .all) {
                                self.page += 2
                            } else {
                                self.page += 1
                            }
                            self.updateNextDisabled()
                        }
                    }) {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .disabled(self.nextDisabled)
                    .foregroundColor(self.nextDisabled ? STARTING_THEME_LIGHT : STARTING_THEME_COLOR)
                } else {
                    Button(action: {
                        self.settings.pickRandom = self.pickRandom
                        self.settings.pickType = self.pickType
                        self.settings.pickSections[self.pickType.rawValue] = self.sectionsList
                        self.settings.notificationsOn = self.notificationsOn!
                        self.settings.notificationsTime = self.notificationsTime
                        self.settings.save()
                        UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                        self.viewRouter.showIntro = false
                    } ) {
                        Image(systemName: "checkmark")
                    }
                    .disabled(self.nextDisabled)
                    .foregroundColor(self.nextDisabled ? STARTING_THEME_LIGHT : STARTING_THEME_COLOR)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .font(FONT_SEMIBOLD_BIG)
        }
        .foregroundColor(STARTING_THEME_COLOR)
    }
    
    func updateNextDisabled() {
        nextDisabled = (page == 2 && sectionsList.isEmpty) || (page == 4 && notificationsOn == nil)
    }
}

/*struct IntroNavigator_Previews: PreviewProvider {
    static var previews: some View {
        IntroNavigator()
    }
}*/
