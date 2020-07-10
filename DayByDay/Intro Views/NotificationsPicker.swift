//
//  NotificationsPicker.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct NotificationsPicker: View {
    @Binding var notificationsOn: Bool?
    @Binding var notificationsTime: Date
    @Binding var nextDisabled: Bool
    @State var presentSheet = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Do you want a daily scripture notification?")
                    .font(FONT_TITLE)
                Spacer()
            }
            Spacer()

            
            
            VStack {
                Spacer().frame(height: 30)
                HStack {
                    Spacer()
                    if (notificationsOn == true) {
                        DatePicker("Time", selection: self.$notificationsTime, displayedComponents: .hourAndMinute)
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
            .overlay(YesNoButton(value: true, notificationsOn: self.$notificationsOn, nextDisabled: self.$nextDisabled, presentSheet: self.$presentSheet), alignment: .top)
            .animation(.linear(duration: 0.12))
            
            YesNoButton(value: false, notificationsOn: self.$notificationsOn, nextDisabled: self.$nextDisabled, presentSheet: self.$presentSheet)
            Spacer()
        }
        .padding(20)
        .sheet(isPresented: self.$presentSheet) {
            GoToSettingsSheet(presentSheet: self.$presentSheet)
        }
    }
    
    struct YesNoButton: View {
        var value: Bool
        @Binding var notificationsOn: Bool?
        @Binding var nextDisabled: Bool
        @Binding var presentSheet: Bool
        
        var body: some View {
            var text = value ? "Yes" : "No"
            if (value && notificationsOn ?? false) {
                text += ", at"
            }
            
            return Button(action: {
                if self.value {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            DispatchQueue.main.async {
                                withAnimation { self.notificationsOn = true }
                            }
                        } else {
                            self.presentSheet = true
                        }
                    }
                } else {
                    withAnimation { self.notificationsOn = false }
                }
                self.nextDisabled = false
            }) {
                VStack {
                    HStack {
                        Spacer()
                        Text(text)
                            .font(FONT_TITLE)
                        Spacer()
                    }
                }
                .padding(20)
                .foregroundColor(Color.white)
                .background(value == notificationsOn ? STARTING_THEME_COLOR : STARTING_THEME_LIGHT)
                .cornerRadius(20)
                .animation(.linear(duration: 0.2))
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.95))
        }
    }
}

/*struct NotificationsPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationsPicker()
                .padding(20)
                .foregroundColor(STARTING_THEME_COLOR)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
            NotificationsPicker()
                .padding(20)
                .foregroundColor(STARTING_THEME_COLOR)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE ")
        }
    }
}*/
