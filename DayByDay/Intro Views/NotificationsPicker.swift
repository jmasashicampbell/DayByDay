//
//  NotificationsPicker.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct NotificationsPicker: View {
    @State var notificationsOn: Bool? = nil
    @State var notificationsTime = Date()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Do you want a daily scripture notification?")
                .font(FONT_TITLE)
            Spacer()

            
            
            VStack {
                Spacer().frame(height: 30)
                HStack {
                    Spacer()
                    if (notificationsOn == true) {
                        DatePicker("Time", selection: $notificationsTime, displayedComponents: .hourAndMinute)
                            .colorInvert()
                            .colorMultiply(Color.white)
                            .labelsHidden()
                            .transition(.opacity)
                    }
                    Spacer()
                }
            }
            .frame(height: notificationsOn == true ? 250 : 74)
            .background(STARTING_THEME_COLOR)
            .cornerRadius(20)
            .overlay(YesNoButton(value: true, notificationsOn: self.$notificationsOn), alignment: .top)
            .animation(.linear(duration: 0.12))
            
            YesNoButton(value: false, notificationsOn: self.$notificationsOn)
            Spacer()
            
            IntroNavigator(disabled: notificationsOn == nil)
        }
        .foregroundColor(STARTING_THEME_COLOR)
        .padding(20)
    }
    
    struct YesNoButton: View {
        var value: Bool
        @Binding var notificationsOn: Bool?
        
        var body: some View {
            Button(action: { withAnimation { self.notificationsOn = self.value } }) {
                VStack {
                    HStack {
                        Spacer()
                        Text(value ? "Yes" : "No")
                            .font(FONT_TITLE)
                        Spacer()
                    }
                }
                .padding(20)
                .foregroundColor(Color.white)
                .background(value == notificationsOn ? STARTING_THEME_COLOR : Color(red: 0.42, green: 0.7, blue: 0.84))
                .cornerRadius(20)
                .animation(.linear(duration: 0.2))
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.95))
        }
    }
}

struct NotificationsPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationsPicker()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
            NotificationsPicker()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE ")
        }
    }
}
