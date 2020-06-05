//
//  RandomPicker.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI

struct RandomPicker: View {
    @Binding var settings: Settings
    
    var body: some View {
        let themeColor = Color(red: 0.1, green: 0.53, blue: 0.75)
        
        return VStack(spacing: 20) {
            HStack {
                Text("Do you want to receive verses in order or randomly?")
                    .font(FONT_TITLE)
                Spacer()
            }
            Spacer().frame(height: 0)
            
            TypeButton(setRandom: false, imageName: "text.justify", text: "In Order", themeColor: themeColor, selectedRandom: self.$settings.pickRandom)
            
            TypeButton(setRandom: true, imageName: "shuffle", text: "Random", themeColor: themeColor, selectedRandom: self.$settings.pickRandom)
            
            Spacer().frame(height: 0)
        }
    }
    
    
    private struct TypeButton: View {
        var setRandom: Bool
        var imageName: String
        var text: String
        var themeColor: Color
        @Binding var selectedRandom: Bool
        
        var body: some View {
            Button(action: {self.selectedRandom = self.setRandom}) {
                HStack {
                    Spacer()
                    VStack {
                        Group {
                            Image(systemName: imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                        }
                        .padding(30)
                        Text(text)
                            .font(FONT_LABEL)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                .padding(20)
                .foregroundColor(Color.white)
                .background(setRandom == selectedRandom ? self.themeColor : Color(red: 0.42, green: 0.7, blue: 0.84) /*self.themeColor.light*/)
                .cornerRadius(20)
                .animation(.linear(duration: 0.2))
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.93))
        }
    }
}

/*struct RandomPicker_Previews: PreviewProvider {
    static var previews: some View {
        RandomPicker(settings: Settings())
            .padding(20)
            .foregroundColor(STARTING_THEME_COLOR)
    }
}*/
