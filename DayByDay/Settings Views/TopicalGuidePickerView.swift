//
//  TopicalGuideView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/10/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct TopicalGuidePickerView: View {
        @EnvironmentObject var settings: Settings
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            let textColor = colorScheme == .dark ? Color.white : Color.black
            let accentColor = self.settings.themeColor.dark()
            
            return Form {
                List {
                    ForEach(PickType.allCases, id: \.self) { pickType in
                        Button(action: {
                            if (self.settings.pickSectionsContains(path: child.path)) {
                                self.settings.removePickSection(path: child.path)
                            } else {
                                self.settings.addPickSection(path: child.path)
                            }
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

struct TopicalGuidePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TopicalGuidePickerView()
    }
}
