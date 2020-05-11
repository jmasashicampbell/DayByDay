//
//  SettingsPickerVIew.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/8/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI


struct PickPickerView: View {
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
                            PickPickerView(node: child,
                                               depth: self.depth + (child.name == "Doctrine and Covenants" ? 2 : 1),
                                               maxDepth: self.maxDepth)) {
                            HStack {
                                Text(child.name)
                                Spacer()
                                if (self.settings.referencesContains(path: child.path)) {
                                    Text(String(self.settings.referencesCount(path: child.path)))
                                }
                            }
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
                            self.settings.updateStartingVerse()
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
        }
        .navigationBarTitle(node.name)
    }
}


struct SettingsPickerVIew_Previews: PreviewProvider {
    static var previews: some View {
        PickPickerView(node: scriptureTree.root,
                           depth: 1,
                           maxDepth: 1)
    }
}
