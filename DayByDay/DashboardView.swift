//
//  DashboardView.swift
//  DayByDay
//
//  Created by Jerome Campbell on 7/7/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var generatedScriptures: GeneratedScriptures
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var scriptureCompletion = ScriptureCompletion()
    
    var body: some View {
        let allNode = scriptureTree.root
        let oTNode = allNode.getChild(name: "Old Testament")!
        let nTNode = allNode.getChild(name: "New Testament")!
        let bOMNode = allNode.getChild(name: "Book of Mormon")!
        let dCNode = allNode.getChild(name: "Doctrine and Covenants")!
        let pOGPNode = allNode.getChild(name: "Pearl of Great Price")!
        
        return VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(settings.themeColor.dark)
                }
                Spacer()
            }
            
            CircleScale(title: "",
                        verses: scriptureCompletion.getCompletedNum(allNode),
                        maxVerses: allNode.end - allNode.start)
            Text("All Scriptures")
                .font(.system(size: 24, weight: .medium))
                .offset(y: -20)
            
            HStack(spacing: 20) {
                CircleScale(title: "Old Testament",
                            verses: scriptureCompletion.getCompletedNum(oTNode),
                            maxVerses: oTNode.end - oTNode.start)
                
                CircleScale(title: "New Testament",
                            verses: scriptureCompletion.getCompletedNum(nTNode),
                            maxVerses: nTNode.end - nTNode.start)
            }
            
            HStack(spacing: 10) {
                CircleScale(title: "Book of Mormon",
                            verses: scriptureCompletion.getCompletedNum(bOMNode),
                            maxVerses: bOMNode.end - bOMNode.start)
                            //.offset(y: 50)
                
                CircleScale(title: "D&C",
                            verses: scriptureCompletion.getCompletedNum(dCNode),
                            maxVerses: dCNode.end - dCNode.start)
                    //.offset(y: -30)
                
                CircleScale(title: "P of GP",
                            verses: scriptureCompletion.getCompletedNum(pOGPNode),
                            maxVerses: pOGPNode.end - pOGPNode.start)
                            //.offset(y: 50)
            }
            
            //Spacer()
        }
        .padding()
        .onAppear {
            self.scriptureCompletion.updateArray(self.generatedScriptures)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}


class ScriptureCompletion {
    var array: [Bool]
    
    init() {
        let numVerses = scriptureTree.root.end
        array = Array(repeating: false, count: numVerses)
    }
    
    func updateArray(_ generatedScriptures: GeneratedScriptures) {
        for scripture in generatedScriptures.getPast() {
            array[scripture.index] = true
        }
    }
    
    func getCompletedNum(_ range: Node) -> Int {
        let selectedArray = Array(array[range.start..<range.end])
        return selectedArray.reduce(0, { $1 ? $0 + 1: $0 })
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
        .environmentObject(Settings())
        .environmentObject(GeneratedScriptures())
    }
}
