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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var selectedPickType: PickType
    
    var body: some View {
        let textColor = colorScheme == .dark ? Color.white : Color.black
        let accentColor = self.settings.themeColor.dark
        
        return Form {
            List {
                ForEach(PickType.allCases, id: \.self) { pickType in
                    Button(action: {
                        selectedPickType = pickType
                    }) {
                        HStack {
                            Text(pickType.rawValue)
                                .foregroundColor(pickType == selectedPickType ? accentColor : textColor)
                            Spacer()
                            if (pickType == selectedPickType) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .imageScale(.medium)
                                    .foregroundColor(accentColor)
                            }
                        }
                    }
                }
            }
        }.navigationBarItems(
            leading:
                Button(action: {
                    settings.pickType = selectedPickType
                    self.mode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Settings")
                    }
                    .foregroundColor(settings.themeColor.dark)
                }
        )
        .navigationBarBackButtonHidden(true)
    }
}

struct TypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TypePickerView(selectedPickType: PickType.books)
            .environmentObject(Settings())
    }
}
