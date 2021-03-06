//
//  ScriptureDetail.swift
//  DayByDay
//
//  Created by Jerome Campbell on 4/30/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI
import CoreGraphics
import Combine

let BUTTON_SPACE_HEIGHT : CGFloat = 20.0

struct ScriptureDetail: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var generatedScriptures: GeneratedScriptures
    @EnvironmentObject var selectionCoordinator: SelectionCoordinator
    @Binding var openInEdit: Bool
    @State var notes: String
    @State private var keyboardMoveDist: CGFloat = 0
    @State var lastKeyboardHeight: CGFloat = 0
    @State private var showShareSheet = false
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                if (selectionCoordinator.scripture != nil) {
                    VStack(alignment: .leading, spacing: 10.0) {
                        HStack {
                            // Header
                            Text(dateComponentsToString(selectionCoordinator.scripture!.date, format: "E"))
                            .font(FONT_REG_BIG)
                            
                            Text(dateComponentsToString(selectionCoordinator.scripture!.date, format: "MMM dd"))
                            .font(FONT_SEMIBOLD_BIG)
                            Spacer()
                            
                            // Dismiss button
                            Button(action: {
                                self.generatedScriptures.setScriptureNotes(id: selectionCoordinator.scripture!.id, notes: notes)
                                selectionCoordinator.scripture = nil
                            }) {
                                Image(systemName: "chevron.down")
                            }
                            .font(FONT_SEMIBOLD_BIG)
                        }
                        
                        // Text
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10.0) {
                                Text(selectionCoordinator.scripture!.text)
                                    .font(geometry.size.height > 700 ? FONT_LIGHT_PLUS : FONT_LIGHT)
                                
                                Text(selectionCoordinator.scripture!.reference)
                                    .font(FONT_MED)
                            }
                        }
                    }
                    Spacer()
     
                        
                    VStack(spacing: 20) {
                        // Notes
                        MultilineTextField(text: self.$notes, isFirstResponder: self.openInEdit, onCommit: {
                            self.generatedScriptures.setScriptureNotes(id: selectionCoordinator.scripture!.id, notes: self.notes)
                        })
                        .padding(5)
                        .frame(height: 210)
                        .background(self.settings.themeColor.light)
                        .cornerRadius(10)
                        
                        Spacer().frame(height: self.keyboardMoveDist)
                        
                        // Share/Gospel Library buttons
                        Button(action: { self.showShareSheet = true } ) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        
                        Button(action: { UIApplication.shared.open(gospelLibraryLink(selectionCoordinator.scripture!)) }) {
                            Image(systemName: "book")
                            Text("View in Gospel Library")
                        }
                        .padding(.bottom, 20)
                    }
                } else {
                    // Spacer to keep card at full size during transitions
                    HStack {
                        Spacer()
                    }
                    Spacer()
                }
            }
            .padding()
            .font(FONT_SMALL)
            .foregroundColor(self.settings.themeColor.text)
            .background(self.settings.themeColor.main)
            .cornerRadius(20)
            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                if keyboardHeight != self.lastKeyboardHeight {
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputTop = (UIResponder.currentFirstResponder?.globalFrame?.minY ?? 0)
                    self.keyboardMoveDist = max(0, focusedTextInputTop - keyboardTop - geometry.safeAreaInsets.bottom + 130)
                    self.openInEdit = false
                    self.lastKeyboardHeight = keyboardHeight
                }
            }
            .sheet(isPresented: self.$showShareSheet) {
                if (selectionCoordinator.scripture != nil) {
                    ShareSheet(activityItems: [selectionCoordinator.scripture!.text,
                                               selectionCoordinator.scripture!.reference])
                }
            }
        }
        .padding()
        .padding(.bottom, 10)
        .ignoresSafeArea()
    }
}

/*struct ScriptureDetail_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureDetail(scripture: previewContent.generatedScriptures.array[0])
    }
}*/


func gospelLibraryLink(_ scripture: Scripture) -> URL {
    let path = scriptureTree.getPath(index: scripture.index)
    let dAndC = path[1] == "Doctrine and Covenants"
    
    let volume = ABBR[path[1]]!
    let book = dAndC ? "dc" : ABBR[path[2]]!
    let chapter = dAndC ? path[2].components(separatedBy: " ").last! : path[3].components(separatedBy: " ").last!
    let verse = dAndC ? path[3] : path[4]
    
    return URL(string: "gospellibrary://content/scriptures/\(volume)/\(book)/\(chapter).\(verse)?lang=eng")!
}


let ABBR = ["Old Testament": "ot",
            "New Testament": "nt",
            "Book of Mormon": "bofm",
            "Doctrine and Covenants": "dc-testament",
            "Pearl of Great Price": "pgp",
            "Genesis": "gen",
            "Exodus": "ex",
            "Leviticus": "lev",
            "Numbers": "num",
            "Deuteronomy": "deut",
            "Joshua": "josh",
            "Judges": "judg",
            "Ruth": "ruth",
            "1 Samuel": "1-sam",
            "2 Samuel": "2-sam",
            "1 Kings": "1-kgs",
            "2 Kings": "2-kgs",
            "1 Chronicles": "1-chr",
            "2 Chronicles": "2-chr",
            "Ezra": "ezra",
            "Nehemiah": "neh",
            "Esther": "esth",
            "Job": "job",
            "Psalms": "ps",
            "Proverbs": "prov",
            "Ecclesiastes": "eccl",
            "Song of Solomon": "song",
            "Isaiah": "isa",
            "Jeremiah": "jer",
            "Lamentations": "lam",
            "Ezekiel": "ezek",
            "Daniel": "dan",
            "Hosea": "hosea",
            "Joel": "joel",
            "Amos": "amos",
            "Obadiah": "obad",
            "Jonah": "jonah",
            "Micah": "micah",
            "Nahum": "nahum",
            "Habakkuk": "hab",
            "Zephaniah": "zeph",
            "Haggai": "hag",
            "Zechariah": "zech",
            "Malachi": "mal",
            "Matthew": "matt",
            "Mark": "mark",
            "Luke": "luke",
            "John": "john",
            "Acts": "acts",
            "Romans": "rom",
            "1 Corinthians": "1-cor",
            "2 Corinthians": "2-cor",
            "Galatians": "gal",
            "Ephesians": "eph",
            "Philippians": "philip",
            "Colossians": "col",
            "1 Thessalonians": "1-thes",
            "2 Thessalonians": "2-thes",
            "1 Timothy": "1-tim",
            "2 Timothy": "2-tim",
            "Titus": "titus",
            "Philemon": "philem",
            "Hebrews": "hebr",
            "James": "james",
            "1 Peter": "1-pet",
            "2 Peter": "2-pet",
            "1 John": "1-jn",
            "2 John": "2-jn",
            "3 John": "3-jn",
            "Jude": "jude",
            "Revelation": "rev",
            "1 Nephi": "1-ne",
            "2 Nephi": "2-ne",
            "Jacob": "jacob",
            "Enos": "enos",
            "Jarom": "jarom",
            "Omni": "omni",
            "Words of Mormon": "w-of-m",
            "Mosiah": "mosiah",
            "Alma": "alma",
            "Helaman": "hel",
            "3 Nephi": "3-ne",
            "4 Nephi": "4-ne",
            "Mormon": "morm",
            "Ether": "eth",
            "Moroni": "moro",
            "Moses": "moses",
            "Abraham": "abr",
            "Joseph Smith\u{2014}Matthew": "js-m",
            "Joseph Smith\u{2014}History": "js-h",
            "Articles of Faith": "a-of-f"]
