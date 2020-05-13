//
//  PreviewContent.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/12/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
let scripturesArray = [Scripture(index: 15923,
                                 id: 1001,
                                 date: makeComponents(date: Date())),
                       Scripture(index: 23542,
                                 id: 1002,
                                 date: makeComponents(date: Date()))]
let previewContent = PreviewContent()

struct PreviewContent {
    let settings = Settings()
    let generatedScriptures = GeneratedScriptures(array: scripturesArray)
}
