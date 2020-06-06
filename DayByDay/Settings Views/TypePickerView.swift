//
//  TypePickerView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/21/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct TypePickerView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let textColor = colorScheme == .dark ? Color.white : Color.black
        let accentColor = self.settings.themeColor.dark()
        
        return Form {
            List {
                ForEach(PickType.allCases, id: \.self) { pickType in
                    Button(action: {
                        self.settings.pickType = pickType
                    }) {
                        HStack {
                            Text(pickType.rawValue)
                                .foregroundColor(pickType == self.settings.pickType ? accentColor : textColor)
                            Spacer()
                            if (pickType == self.settings.pickType) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .imageScale(.medium)
                                    .foregroundColor(accentColor)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerView()
    }
}
