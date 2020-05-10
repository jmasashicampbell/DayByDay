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
    var depth: Int
    var maxDepth: Int
    var body: some View {
        Form {
            List {
                if (self.depth < self.maxDepth) {
                    ForEach(node.children, id: \.start) { child in
                        NavigationLink(destination:
                            SettingsPickerView(node: child,
                                               depth: self.depth + 1,
                                               maxDepth: self.maxDepth)) {
                            Text(child.name)
                        }
                    }
                } else {
                    ForEach(node.children, id: \.start) { child in
                        Button(action: {}) {
                            Text(child.name)
                        }
                    }
                }
            }
        }.navigationBarTitle(node.name)
    }
}


struct SettingsPickerVIew_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPickerView(node: scriptureTree.root,
                           depth: 1,
                           maxDepth: 3)
    }
}
