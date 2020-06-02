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
    @State var scripture: Scripture
    @Binding var scriptureSelected: Bool
    @State private var keyboardMoveDist: CGFloat = 0
    @State private var showShareSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10.0) {
                    HStack {
                        Text(dateComponentsToString(self.scripture.date, format: "E"))
                        .font(REG_BIG_FONT)
                        
                        Text(dateComponentsToString(self.scripture.date, format: "MMM dd"))
                        .font(SEMIBOLD_BIG_FONT)
                        Spacer()
                        
                        Button(action: {
                            self.generatedScriptures.setScriptureNotes(id: self.scripture.id, notes: self.scripture.notes)
                            self.scriptureSelected.toggle()
                        }) {
                            Image(systemName: "chevron.down")
                        }
                        .font(SEMIBOLD_BIG_FONT)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text(self.scripture.text)
                                .font(LIGHT_FONT)
                            
                            Text(self.scripture.reference)
                                .font(MED_FONT)
                        }
                    }
                    .animation(nil)
                }
                
                Spacer()
                    
                VStack(spacing: 20) {
                    MultilineTextField("Add a note", text: self.$scripture.notes, onCommit: {
                        self.generatedScriptures.setScriptureNotes(id: self.scripture.id, notes: self.scripture.notes)
                    })
                    .padding(5)
                    .frame(height: 210)
                    .background(self.settings.themeColor.light())
                    .cornerRadius(10)
                    
                    Spacer().frame(height: self.keyboardMoveDist)
                    
                    Button(action: { self.showShareSheet = true } ) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    
                    Button(action: { UIApplication.shared.open(gospelLibraryLink(self.scripture)) }) {
                        Image(systemName: "book")
                        Text("View in Gospel Library")
                    }
                }
            }
            .padding(20)
            .font(SMALL_FONT)
            .foregroundColor(self.settings.themeColor.text())
            .background(self.settings.themeColor.main())
            .cornerRadius(20)
            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                let focusedTextInputTop = UIResponder.currentFirstResponder?.globalFrame?.minY ?? 0
                self.keyboardMoveDist = max(0, focusedTextInputTop - keyboardTop - geometry.safeAreaInsets.bottom + 100)
            }
            .sheet(isPresented: self.$showShareSheet) {
                ShareSheet(activityItems: [self.scripture.text, self.scripture.reference])
            }
        }
        .padding()
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
            "Moses": "",
            "Abraham": "",
            "Joseph Smith\u{2014}Matthew": "",
            "Joseph Smith\u{2014}History": "",
            "Articles of Faith": ""]
