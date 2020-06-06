//
//  SectionPicker.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/4/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct SectionPicker: View {
    var pickType = PickType.books
    @Binding var sectionsList: [[String]]
    @Binding var nextDisabled: Bool
    @State var showPickerSheet = false
    
    var body: some View {
        let start = pickType.rawValue.startIndex
        let end = pickType.rawValue.index(pickType.rawValue.startIndex, offsetBy: pickType.rawValue.count - 1)
        let pickTypeSingular = String(pickType.rawValue[start..<end])
        
        let maxDepthMap = [PickType.volumes: 1,
                           PickType.books: 2,
                           PickType.chapters: 3]
        
        let volumeNames = ["Old Testament", "New Testament", "Book of Mormon", "Doctrine and Covenants", "Pearl of Great Price"]
        
        return GeometryReader { geometry in
            VStack(spacing: 10) {
                HStack {
                    Text("Choose \(self.pickType.rawValue.lowercased()) from which to receive verses.")
                        .font(FONT_TITLE)
                    Spacer()
                }
                Spacer()
                
                if (self.pickType == .volumes) {
                    VStack(spacing: 10) {
                        ForEach(volumeNames, id: \.self) { volumeName in
                            VolumeListEntry(text: volumeName, sectionsList: self.$sectionsList, nextDisabled: self.$nextDisabled)
                        }
                    }
                } else {
                    if (self.sectionsList.count > 7) {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(self.sectionsList, id: \.self.last!) { path in
                                    AddedListEntry(path: path, sectionsList: self.$sectionsList, width: geometry.size.width, nextDisabled: self.$nextDisabled)
                                }
                                Spacer().frame(height: 0)
                                
                                Button(action: {
                                    self.showPickerSheet.toggle()
                                }) {
                                    Image(systemName: "plus")
                                    Text("Add \(pickTypeSingular)")
                                }
                                .font(FONT_LABEL)
                            }
                        }
                    } else {
                        VStack(spacing: 10) {
                            ForEach(self.sectionsList, id: \.self.last!) { path in
                                AddedListEntry(path: path, sectionsList: self.$sectionsList, width: geometry.size.width, nextDisabled: self.$nextDisabled)
                            }
                            Spacer().frame(height: 0)
                            
                            Button(action: {
                                self.showPickerSheet.toggle()
                            }) {
                                Image(systemName: "plus")
                                Text("Add \(pickTypeSingular)")
                            }
                            .font(FONT_LABEL)
                        }
                    }
                }
                Spacer()
            }
            .sheet(isPresented: self.$showPickerSheet) {
                SectionPickerSheet(node: scriptureTree.root,
                                   depth: 1,
                                   maxDepth: maxDepthMap[self.pickType] ?? 3,
                                   pickSections: self.$sectionsList,
                                   showSheet: self.$showPickerSheet,
                                   nextDisabled: self.$nextDisabled)
            }
        }
        .padding(20)
    }
    
    struct VolumeListEntry: View {
        var text: String
        @Binding var sectionsList: [[String]]
        @Binding var nextDisabled: Bool
        
        var body: some View {
            Button(action: {
                if (self.sectionsList.contains(["Scriptures", self.text])) {
                    self.sectionsList.removeAll { $0 == ["Scriptures", self.text] }
                } else {
                    self.sectionsList.append(["Scriptures", self.text])
                }
                self.nextDisabled = self.sectionsList.isEmpty
            }) {
                HStack {
                    Text(self.text)
                    Spacer()
                    if (self.sectionsList.contains(["Scriptures", text])) {
                        Image(systemName: "checkmark")
                    }
                }
                .font(FONT_LABEL)
                .padding(20)
                .foregroundColor(Color.white)
                .background(self.sectionsList.contains(["Scriptures", text]) ? STARTING_THEME_COLOR : STARTING_THEME_LIGHT)
                .cornerRadius(20)
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.95))
        }
    }
    
    struct AddedListEntry: View {
        var path: [String]
        @Binding var sectionsList: [[String]]
        var width: CGFloat
        @Binding var nextDisabled: Bool
        @State var showDelete = false
        
        var body: some View {
            ZStack {
                HStack {
                    Text(self.path.last!)
                    Spacer()
                    Button(action: {
                        withAnimation { self.showDelete.toggle() }
                    }) {
                        Image(systemName: self.showDelete ? "chevron.right" : "minus.circle.fill")
                    }
                }
                .font(FONT_LABEL)
                .padding(15)
                .foregroundColor(Color.white)
                .background(STARTING_THEME_COLOR)
                .cornerRadius(20)
                .offset(x: self.showDelete ? -60 : 0)
                
                if self.showDelete {
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.sectionsList.removeAll { $0 == self.path }
                                self.nextDisabled = self.sectionsList.isEmpty
                            }
                        } ) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.red)
                        }
                    }
                    .font(FONT_LABEL)
                    .offset(x: self.width / 2 - 30)
                }
            }
        }
    }
    
    struct SectionPickerSheet: View {
        @State var node: Node
        @State var depth: Int
        @State var maxDepth: Int
        @Binding var pickSections: [[String]]
        @Binding var showSheet: Bool
        @Binding var nextDisabled: Bool
        
        var body: some View {
            VStack {
                HStack {
                    if (node.parent != nil) {
                        Button(action: {
                            self.node = self.node.parent!
                            self.depth = (self.node.name == "Doctrine and Covenants" ? 2 : 1)
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                    Spacer()
                    Button(action: {
                        self.showSheet = false
                    }) {
                        Image(systemName: "chevron.down")
                    }
                }
                .font(FONT_SEMIBOLD_BIG)
                //.padding(.top, 20)
                .padding(20)
                .padding(.bottom, -10)
                Form {
                    if (self.depth < self.maxDepth) {
                        NavigationRows(node: $node, depth: $depth)
                    } else {
                        SelectionRows(node: node, pickSections: $pickSections, showSheet: $showSheet, nextDisabled: self.$nextDisabled)
                    }
                }
            }
        }
        
        struct NavigationRows: View {
            @Binding var node: Node
            @Binding var depth: Int
            
            var body: some View {
                List {
                    ForEach(node.children, id: \.start) { child in
                        Button(action: {
                            self.node = child
                            self.depth += (child.name == "Doctrine and Covenants" ? 2 : 1)
                        } ) {
                            Text(child.name)
                            .foregroundColor(STARTING_THEME_COLOR)
                            .font(FONT_MED)
                        }
                    }
                }
            }
        }

        struct SelectionRows: View {
            var node: Node
            @Binding var pickSections: [[String]]
            @Binding var showSheet: Bool
            @Binding var nextDisabled: Bool
            
            var body: some View {
                List {
                    ForEach(node.children, id: \.start) { child in
                        Group {
                            if (!self.pickSections.contains(child.path)) {
                                Button(action: {
                                    self.pickSections.append(child.path)
                                    self.nextDisabled = self.pickSections.isEmpty
                                    self.showSheet.toggle()
                                }) {
                                    HStack {
                                        Text(child.name)
                                        Spacer()
                                    }
                                    .foregroundColor(STARTING_THEME_COLOR)
                                    .font(FONT_MED)
                                }
                            } else {
                                Text(child.name)
                                .foregroundColor(Color.gray)
                                .font(FONT_MED)
                            }
                        }
                    }
                }
            }
        }
    }
}



/*struct SectionPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SectionPicker()
                .padding(20)
                .foregroundColor(STARTING_THEME_COLOR)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
            SectionPicker()
                .padding(20)
                .foregroundColor(STARTING_THEME_COLOR)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE")
        }
    }
}*/
