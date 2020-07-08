//
//  ScriptureArray.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/11/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation


let file = bundleUrlFromFilename("scriptures.json")
let scriptureArray: [Verse] = try! load(file)
