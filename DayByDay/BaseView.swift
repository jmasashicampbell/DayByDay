//
//  BaseView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 9/6/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct BaseView: View {
    @EnvironmentObject var generatedScriptures: GeneratedScriptures
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ScriptureList()
            .sheet(isPresented: $viewRouter.showIntro) {
                IntroNavigator()
                    .environmentObject(self.settings)
                    .environmentObject(self.viewRouter)
                    .environmentObject(self.generatedScriptures)
            }
    }
}


struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
