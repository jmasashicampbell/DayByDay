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
                
            YesNoButton(value: true,
                        notificationsOn: self.$notificationsOn,
                        nextDisabled: self.$nextDisabled,
                        presentSheet: self.$presentSheet,
                        notificationsTime: $notificationsTime)
            
            YesNoButton(value: false,
                        notificationsOn: self.$notificationsOn,
                        nextDisabled: self.$nextDisabled,
                        presentSheet: self.$presentSheet,
                        notificationsTime: .constant(Date()))
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
        @Binding var notificationsTime: Date
        
        var body: some View {
            var text = value ? "Yes" : "No"
            if (value && notificationsOn ?? false) {
                text += ", at"
            }
            
            return Button(action: switchChoice) {
                HStack {
                    Spacer()
                    Text(text)
                        .font(FONT_TITLE)
                    if (value && notificationsOn == true) {
                        Spacer().frame(width: 130)
                    }
                    Spacer()
                }
                .padding(20)
                .foregroundColor(Color.white)
                .background(value == notificationsOn ? STARTING_THEME_SELECTED : STARTING_THEME_UNSELECTED)
                .cornerRadius(20)
                .scaleEffect(value == notificationsOn ? 1.0 : 0.95)
                .animation(.linear(duration: 0.2), value: notificationsOn)
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.95, animated: false))
            .overlay(
                Group {
                    if (value && notificationsOn == true) {
                        Spacer().frame(width: 40)
                        DatePicker("Time", selection: self.$notificationsTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .colorMultiply(Color(hue: 0.00, saturation: 1.0, brightness: 1.0))
                            .contrast(1.5)
                            .colorInvert()
                            .labelsHidden()
                            .transition(.opacity)
                            .frame(width: 100, height: 20)
                            .scaleEffect(1.5)
                            .offset(x: 60, y: 0)
                    }
                }
            )
        }
        
        func switchChoice() {
            if self.value {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            withAnimation { self.notificationsOn = true }
                            self.nextDisabled = false
                        }
                    } else {
                        self.presentSheet = true
                    }
                }
            } else {
                withAnimation { self.notificationsOn = false }
                self.nextDisabled = false
            }
        }
    }
}

struct NotificationsPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("")
            .sheet(isPresented: .constant(true)) {
                NotificationsPicker(notificationsOn: .constant(true),
                                    notificationsTime: .constant(Date()),
                                    nextDisabled: .constant(true))
                    .foregroundColor(Color.white)
                    .background(STARTING_THEME_COLOR)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                    .previewDisplayName("iPhone 11")
            }
        }
    }
}

