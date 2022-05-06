//
//  StartingPickerView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/11/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI


struct StartingPickerView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var node: Node
    @State var selectedPath: [String]
    
    var body: some View {
        StartingBodyView(node: node, selectedPath: $selectedPath)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.settings.setTomorrowVerse(path: selectedPath)
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


struct StartingInnerWrapper: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var node: Node
    @Binding var selectedPath: [String]
    
    var body: some View {
        StartingBodyView(node: node, selectedPath: $selectedPath)
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


struct StartingBodyView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var node: Node
    @Binding var selectedPath: [String]

    var body: some View {
        Form {
            if (!node.children.isEmpty) {
                NavigationRows(
                    nodes: node.children.filter({ settings.pickSectionsContains(path: $0.path) }),
                    selectedPath: $selectedPath
                )
            } else {
                SelectionRows(node: self.node, selectedPath: $selectedPath)
            }
        }
    }
    
    struct NavigationRows: View {
        var nodes: [Node]
        @Binding var selectedPath: [String]
        var body: some View {
            List {
                ForEach(nodes, id: \.start) { node in
                    NavigationLink(destination: StartingInnerWrapper(node: node, selectedPath: $selectedPath)) {
                        Text(node.name)
                    }
                }
            }
        }
    }
    
    struct SelectionRows: View {
        var node: Node
        @Binding var selectedPath: [String]
        
        var body: some View {
            List {
                ForEach(1...node.end - node.start, id: \.self) { verseNum in
                    Button(action: {
                        self.selectedPath = self.node.path + [String(verseNum)]
                        
                    }) {
                        SelectionRow(node: self.node, verseNum: verseNum, selectedPath: $selectedPath)
                    }
                }
            }
        }
        
        struct SelectionRow: View {
            @EnvironmentObject var settings: Settings
            @Environment(\.colorScheme) var colorScheme
            var node: Node
            var verseNum: Int
            @Binding var selectedPath: [String]
            
            var body: some View {
                let textColor = colorScheme == .dark ? Color.white : Color.black
                let accentColor = self.settings.themeColor.dark
                let selected = selectedPath == self.node.path + [String(verseNum)]
                
                return HStack {
                    Text(self.node.name + ":" + String(verseNum))
                        .foregroundColor(selected ? accentColor : textColor)
                    Spacer()
                    if selected {
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

struct StartingPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StartingPickerView(node: scriptureTree.root, selectedPath: [])
            .environmentObject(Settings())
    }
}
