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
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Form {
            List {
                if (self.depth < self.maxDepth) {
                    ForEach(node.children, id: \.start) { child in
                        NavigationLink(destination:
                            SettingsPickerView(node: child,
                                               depth: self.depth + (child.name == "Doctrine and Covenants" ? 2 : 1),
                                               maxDepth: self.maxDepth)) {
                            Text(child.name)
                        }
                    }
                } else {
                    ForEach(node.children, id: \.start) { child in
                        Button(action: {
                            if (self.settings.references.contains(child.path)) {
                                self.settings.references = self.settings.references.filter {$0 != child.path}
                            } else {
                                self.settings.references.append(child.path)
                            }
                            print(self.settings.references)
                        }) {
                            HStack {
                                Text(child.name)
                                Spacer()
                                if (self.settings.references
                                    .contains(child.path)) {
                                    Image(systemName: "checkmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .imageScale(.medium)
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle(node.name)
    }
}


func toggleRow(node: Node) {
    
}


struct SettingsPickerVIew_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPickerView(node: scriptureTree.root,
                           depth: 1,
                           maxDepth: 1)
    }
}
