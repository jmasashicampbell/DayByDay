//
//  SettingsPickerVIew.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/8/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI


struct SectionPickerView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var node: Node
    var depth: Int
    var maxDepth: Int
    @State var pickSections: [[String]]
    
    var body: some View {
        SectionBodyView(node: node, depth: depth, maxDepth: maxDepth, pickSections: $pickSections)
            .navigationBarItems(
                leading:
                    Button(action: {
                        settings.updatePickSections(sections: pickSections)
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
            .navigationBarTitle(node.name)
    }
    
}

struct SectionInnerWrapper: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var node: Node
    var depth: Int
    var maxDepth: Int
    @Binding var pickSections: [[String]]
    
    var body: some View {
        SectionBodyView(node: node, depth: depth, maxDepth: maxDepth, pickSections: $pickSections)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text(node.parent?.name ?? "")
                        }
                        .foregroundColor(settings.themeColor.dark)
                    }
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(node.name)
    }
    
}


struct SectionBodyView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var node: Node
    var depth: Int
    var maxDepth: Int
    @Binding var pickSections: [[String]]
    
    var body: some View {
        Form {
            if (self.depth < self.maxDepth) {
                NavigationRows(node: node, depth: depth, maxDepth: maxDepth, pickSections: $pickSections)
            } else {
                SelectionRows(node: node, depth: depth, maxDepth: maxDepth, pickSections: $pickSections)
            }
        }
    }
    
    struct NavigationRows: View {
        @EnvironmentObject var settings: Settings
        var node: Node
        var depth: Int
        var maxDepth: Int
        @Binding var pickSections: [[String]]
        
        var body: some View {
            List {
                ForEach(node.children, id: \.start) { child in
                    NavigationLink(destination:
                        SectionInnerWrapper(
                            node: child,
                            depth: self.depth + (child.name == "Doctrine and Covenants" ? 2 : 1),
                            maxDepth: self.maxDepth,
                            pickSections: $pickSections)
                    ) {
                        HStack {
                            Text(child.name)
                            Spacer()
                            if countMatches(path: child.path) > 0 {
                                Text(String(countMatches(path: child.path)))
                            }
                        }
                    }
                }
            }
        }
        
        func countMatches(path: [String]) -> Int {
            return pickSections.reduce(0, { count, section in
                path == Array(section[0..<path.count]) ? count + 1 : count
            })
        }
    }

    struct SelectionRows: View {
        @EnvironmentObject var settings: Settings
        @Environment(\.colorScheme) var colorScheme
        var node: Node
        var depth: Int
        var maxDepth: Int
        @Binding var pickSections: [[String]]
        
        var body: some View {
            let textColor = colorScheme == .dark ? Color.white : Color.black
            let accentColor = self.settings.themeColor.dark
            
            return List {
                ForEach(node.children, id: \.start) { child in
                    Button(action: {
                        if pickSections.contains(child.path) {
                            pickSections = pickSections.filter {$0 != child.path}
                        } else {
                            pickSections.append(child.path)
                        }
                    }) {
                        HStack {
                            Text(child.name)
                                .foregroundColor(pickSections.contains(child.path) ? accentColor : textColor)
                            Spacer()
                            if (pickSections.contains(child.path)) {
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


struct SettingsPickerVIew_Previews: PreviewProvider {
    static var previews: some View {
        SectionPickerView(
            node: scriptureTree.root,
            depth: 1,
            maxDepth: 1,
            pickSections: []
        ).environmentObject(Settings())
    }
}
