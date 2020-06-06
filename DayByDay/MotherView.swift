//
//  MotherView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/5/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.showIntro {
                IntroNavigator()
            } else  {
                ScriptureList()
            }
        }
    }
}


class ViewRouter: ObservableObject {
    @Published var showIntro: Bool
    
    init() {
        showIntro = !UserDefaults.standard.bool(forKey: "didLaunchBefore")
    }
}
