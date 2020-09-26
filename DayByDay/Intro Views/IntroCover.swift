//
//  IntroCover.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/5/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct IntroCover: View {
    var body: some View {
        VStack {
            Text("Welcome to Day By Day")
                .font(.system(size: 50, weight: .semibold))
            Spacer()
            Image("icon_blue")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Text("Let's set up your daily scriptures.")
                .font(FONT_TITLE)
        }
        .padding(40)
        .foregroundColor(Color.white)
    }
}

struct IntroCover_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
        .sheet(isPresented: .constant(true)) {
            IntroCover()
        }
    }
}
