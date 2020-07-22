//
//  TypePicker.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/3/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import SwiftUI

struct TypePicker: View {
    @Binding var selectedType: PickType
    @Binding var sectionsList: [[String]]
    var transitionType: AnyTransition
    var temp: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("From where would you like to receive verses?")
                    .font(FONT_TITLE)
                Spacer()
            }
            Spacer()

            VStack {
                HStack(spacing: 30) {
                    TypeButton(type: .volumes, imageName: "type_volumes", text: "Volumes", selectedType: self.$selectedType, sectionsList: self.$sectionsList, transitionType: self.transitionType)
                    TypeButton(type: .books, imageName: "type_books", text: "Books", selectedType: self.$selectedType, sectionsList: self.$sectionsList, transitionType: self.transitionType)
                }
                Spacer().frame(height: 35)
                
                HStack(spacing: 30) {
                    TypeButton(type: .chapters, imageName: "type_chapters", text: "Chapters", selectedType: self.$selectedType, sectionsList: self.$sectionsList, transitionType: self.transitionType)
                    TypeButton(type: .topicalGuide, imageName: "type_topical_guide", text: "Topical Guide", selectedType: self.$selectedType, sectionsList: self.$sectionsList, transitionType: self.transitionType)
                }
            }
            .padding(20)
            Spacer()//.frame(height: 20)
            
            Text(captionText(selectedType))
                .font(FONT_MED)
            Spacer()
            Spacer()
        }
        .padding(20)
    }
    
    private func captionText(_ type: PickType) -> String {
        switch type {
        case .volumes:
            return "Choose volumes (such as the Book of Mormon) from which to receive verses."
        case .books:
            return "Choose books (such as 1 Nephi, Isaiah) from which to receive verses."
        case .chapters:
            return "Choose chapters (such as Luke 2, Jacob 5) from which to receive verses."
        case .topicalGuide:
            return "Choose entries from the Topical Guide from which to receive verses."
        }
    }
    
    private struct TypeButton: View {
        var type: PickType
        var imageName: String
        var text: String
        @Binding var selectedType: PickType
        @Binding var sectionsList: [[String]]
        var transitionType: AnyTransition
        
        var body: some View {
            Button(action: self.setType) {
                VStack(spacing: 0) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                    Text(text)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                }
                .padding(10)
                .foregroundColor(Color.white)
                .background(type == selectedType ? STARTING_THEME_SELECTED : STARTING_THEME_UNSELECTED)
                .cornerRadius(20)
                .scaleEffect(type == selectedType ? 1.2 : 1.0)
                .animation(.linear(duration: 0.2))
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.93, animated: false))
        }
        
        func setType() {
            self.selectedType = self.type
            self.sectionsList = []
        }
    }
}

struct TypePicker_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                TypePicker(selectedType: .constant(.volumes), sectionsList: .constant([]), transitionType: .slide)
                .background(STARTING_THEME_COLOR)
        }
    }
}
