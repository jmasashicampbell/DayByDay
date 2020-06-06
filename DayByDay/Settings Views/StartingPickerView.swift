//
//  StartingPickerView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/11/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct StartingPickerView: View {
    var node: Node
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Form {
            if (!node.children.isEmpty) {
                NavigationRows(nodes: node.children.filter({ settings.pickSectionsContains(path: $0.path)
                }))
            } else {
                SelectionRows(node: self.node)
            }
        }
            .navigationBarTitle(node.name)
    }
    
    struct NavigationRows: View {
        var nodes: [Node]
        var body: some View {
            List {
                ForEach(nodes, id: \.start) { node in
                    NavigationLink(destination: StartingPickerView(node: node)) {
                        Text(node.name)
                    }
                }
            }
        }
    }
    
    struct SelectionRows: View {
        var node: Node
        @EnvironmentObject var settings: Settings
        
        var body: some View {
            List {
                ForEach(1...node.end - node.start, id: \.self) { verseNum in
                    Button(action: {self.settings.setTomorrowVerse(path: self.node.path + [String(verseNum)])}) {
                        SelectionRow(node: self.node, verseNum: verseNum)
                    }
                }
            }
        }
        
        struct SelectionRow: View {
            var node: Node
            var verseNum: Int
            @EnvironmentObject var settings: Settings
            @Environment(\.colorScheme) var colorScheme
            
            var body: some View {
                let textColor = colorScheme == .dark ? Color.white : Color.black
                let accentColor = self.settings.themeColor.dark()
                let selected = self.settings.getTomorrowVerse() == self.node.path + [String(verseNum)]
                
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
        StartingPickerView(node: scriptureTree.root)
    }
}
