//
//  GoToSettingsView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/10/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct GoToSettingsSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var presentSheet: Bool
    var settings = Settings()
    
    var body: some View {
        let mode = self.colorScheme == .light ? "light" : "dark"
        
        return VStack(spacing: 20) {
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
        .font(FONT_SEMIBOLD_BIG)
        .edgesIgnoringSafeArea(.all)
    }
}

/*struct GoToSettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        GoToSettingsSheet(presentSheet: <#T##Binding<Bool>#>)
    }
}*/
