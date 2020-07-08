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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("From where would you like to receive verses?")
                    .font(FONT_TITLE)
                Spacer()
            }
            Spacer()

            
            HStack(spacing: 15) {
                TypeButton(type: .all, imageName: "type_all", text: "All", selectedType: self.$selectedType)
                TypeButton(type: .volumes, imageName: "type_volumes", text: "Volumes", selectedType: self.$selectedType)
            }
            Spacer().frame(height: 15)
            
            HStack(spacing: 15) {
                TypeButton(type: .books, imageName: "type_books", text: "Books", selectedType: self.$selectedType)
                TypeButton(type: .chapters, imageName: "type_chapters", text: "Chapters", selectedType: self.$selectedType)
            }
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
        case .all:
            return "Receive verses from anywhere in the scriptures."
        case .volumes:
            return "Choose volumes (such as the Book of Mormon) from which to receive verses."
        case .books:
            return "Choose books (such as 1 Nephi, Isaiah) from which to receive verses."
        case .chapters:
            return "Choose chapters (such as Luke 2, Jacob 5) from which to receive verses."
        }
    }
    
    private struct TypeButton: View {
        var type: PickType
        var imageName: String
        var text: String
        @Binding var selectedType: PickType
        
        var body: some View {
            Button(action: {self.selectedType = self.type}) {
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
                .background(type == selectedType ? STARTING_THEME_COLOR : STARTING_THEME_LIGHT)
                .cornerRadius(20)
                .animation(.linear(duration: 0.2))
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: 0.93))
        }
    }
}

/*struct TypePicker_Previews: PreviewProvider {
    static var previews: some View {
        TypePicker()
            .padding(20)
            .foregroundColor(STARTING_THEME_COLOR)
    }
}*/
