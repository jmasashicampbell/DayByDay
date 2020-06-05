//
//  IntroNavigator.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct IntroNavigator: View {
    @State var settings = Settings()
    @State var pickRandom = false
    @State var selectedType = PickType.all
    @State var sectionsList: [[String]] = []
    @State var notificationsOn: Bool? = nil
    @State var notificationsTime = Date()
    
    @State var page = 0
    @State var nextDisabled: Bool = false
    
    var body: some View {
        VStack {
            if (page == 0) {
                RandomPicker(pickRandom: self.$pickRandom)
            } else if (page == 1) {
                TypePicker(selectedType: self.$selectedType)
            } else if (page == 2) {
                SectionPicker(pickType: self.selectedType, sectionsList: self.$sectionsList)
            } else if (page == 3) {
                NotificationsPicker(notificationsOn: self.$notificationsOn, notificationsTime: self.$notificationsTime)
            }
            
            HStack {
                if (self.page != 0) {
                    Button(action: { self.page -= 1 }) {
                        Image(systemName: "chevron.left")
                    }
                }
                Spacer()
                if (self.page != 3) {
                    Button(action: { self.page += 1 }) {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .disabled(self.nextDisabled)
                    .foregroundColor(self.nextDisabled ? Color(red: 0.42, green: 0.7, blue: 0.84) : STARTING_THEME_COLOR)
                }
            }
            .font(FONT_SEMIBOLD_BIG)
        }
        .padding(20)
        .foregroundColor(STARTING_THEME_COLOR)
    }
}

struct IntroNavigator_Previews: PreviewProvider {
    static var previews: some View {
        IntroNavigator()
    }
}
