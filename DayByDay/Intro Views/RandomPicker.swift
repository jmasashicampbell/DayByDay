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
    @Binding var pickRandom: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Do you want to receive verses in order or randomly?")
                    .font(FONT_TITLE)
                Spacer()
            }
            Spacer().frame(height: 0)
            
            TypeButton(setRandom: false, imageName: "text.justify", text: "In Order", selectedRandom: self.$pickRandom)
            
            TypeButton(setRandom: true, imageName: "shuffle", text: "Random", selectedRandom: self.$pickRandom)
            
            Spacer().frame(height: 0)
        }
        .padding(20)
    }
    
    
    private struct TypeButton: View {
        var setRandom: Bool
        var imageName: String
        var text: String
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
                .background(setRandom == selectedRandom ? STARTING_THEME_SELECTED : STARTING_THEME_UNSELECTED)
                .cornerRadius(20)
                .scaleEffect(setRandom == selectedRandom ? 1.0 : 0.95)
                .animation(.linear(duration: 0.2), value: setRandom == selectedRandom)
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.93, animated: false))
        }
    }
}

/*struct RandomPicker_Previews: PreviewProvider {
    static var previews: some View {
        RandomPicker()
            .padding(20)
            .foregroundColor(STARTING_THEME_COLOR)
    }
}*/
