//
//  SettingsPickerVIew.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/8/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

let scriptureTree = ScriptureTree()

struct SettingsPickerView: View {
    var node: Node
    var body: some View {
        Form {
            List {
                ForEach(node.children, id: \.start) { child in
                    Text(child.name)
                }
            }
        }.navigationBarTitle(node.name)
    }
}

struct SettingsPickerVIew_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPickerView(node: scriptureTree.root)
    }
}
