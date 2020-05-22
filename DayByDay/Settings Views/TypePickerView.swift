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
    
    var body: some View {
        Form {
            List {
                ForEach(PickType.allCases, id: \.self) { pickType in
                    Button(action: {
                        self.settings.pickType = pickType
                    }) {
                        HStack {
                            Text(pickType.rawValue)
                            Spacer()
                            if (pickType == self.settings.pickType) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .imageScale(.medium)
                                    .foregroundColor(self.settings.themeColor.dark())
                            }
                        }
                    }
                }
            }
        }
        //.navigationBarTitle("")
    }
}

struct TypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerView()
    }
}
