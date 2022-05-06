//
//  ScriptureWidget.swift
//  ScriptureWidget
//
//  Created by Jerome Campbell on 1/23/22.
//  Copyright © 2022 Jerome Campbell. All rights reserved.
//

import WidgetKit
import SwiftUI

let SCRIPTURE_INFO_SPACING: CGFloat = 5



let EXAMPLE_SCRIPTURE = Scripture(
    id: 0,
    date: makeComponents(date: Date()),
    reference: "1 Nephi 1:1",
    text: "I, Nephi, having been born ",
    notes: "",
    index: 0
)

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScriptureEntry {
        let scripture = EXAMPLE_SCRIPTURE
        return ScriptureEntry(date: Date(), scripture: scripture)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScriptureEntry) -> ()) {
        let entry = placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ScriptureEntry] = []

        let currentDate = Date()
        let scripture = EXAMPLE_SCRIPTURE
        entries.append(ScriptureEntry(date: currentDate, scripture: scripture))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ScriptureEntry: TimelineEntry {
    let date: Date
    let scripture: Scripture
}

struct ScriptureWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            ScriptureInfo(
                scripture: entry.scripture,
                widgetFonts: .small
            )
        case .systemMedium:
            ScriptureInfo(
                scripture: entry.scripture,
                widgetFonts: .medium
            )
        default:
            ScriptureInfo(
                scripture: entry.scripture,
                widgetFonts: .large
            )
        }
    }
}

struct ScriptureInfo: View {
    @Environment(\.widgetFamily) var family
    
    var scripture: Scripture
    var widgetFonts: WidgetFonts
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0.0) {
                // Header
                HStack {
                    Text(dateComponentsToString(scripture.date, format: "E"))
                        .font(widgetFonts.weekdayFont)
                    
                    Text(dateComponentsToString(scripture.date, format: "MMM dd"))
                        .font(widgetFonts.dateFont)
                }
                Spacer().frame(height: SCRIPTURE_INFO_SPACING)
                
                // Text
                Text(scripture.text)
                    .font(widgetFonts.textFont)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: SCRIPTURE_INFO_SPACING)
                Text(scripture.reference)
                    .font(widgetFonts.referenceFont)
                Spacer()
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
}

@main
struct ScriptureWidget: Widget {
    let kind: String = "ScriptureWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScriptureWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ScriptureWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        let entry = ScriptureEntry(date: Date(), scripture: EXAMPLE_SCRIPTURE)
        
        Group {
            ScriptureWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            ScriptureWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            ScriptureWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
