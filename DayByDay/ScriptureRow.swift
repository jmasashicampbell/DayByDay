//
//  ScriptureRow.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct ScriptureRow: View {
    var scripture: Scripture
    var body: some View {
        VStack {
            Text(String(format:"%f", scripture.date))
            Text(scripture.text)
                .padding()
            Text(scripture.reference)
        }
    }
}

struct ScriptureRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScriptureRow(scripture: scriptureData[0])
            ScriptureRow(scripture: scriptureData[1])
        }
        .previewLayout(.fixed(width: 300, height: 200))
    }
}
