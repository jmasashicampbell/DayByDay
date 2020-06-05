//
//  IntroNavigator.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct IntroNavigator: View {
    @State var page = 0
    @State var nextDisabled: Bool = false
    
    var body: some View {
        VStack {
            if (page == 0) {
                RandomPicker()
            } else if (page == 1) {
                TypePicker()
            } else if (page == 2) {
                SectionPicker()
            } else if (page == 3) {
                NotificationsPicker()
            }
            
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Button(action: {}) {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
                .disabled(self.nextDisabled)
                .foregroundColor(self.nextDisabled ? Color(red: 0.42, green: 0.7, blue: 0.84) : STARTING_THEME_COLOR)
            }
            .font(FONT_SEMIBOLD_BIG)
        }
    }
}

struct IntroNavigator_Previews: PreviewProvider {
    static var previews: some View {
        IntroNavigator()
    }
}
