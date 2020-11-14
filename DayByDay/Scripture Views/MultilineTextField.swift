//
//  MultilineTextField.swift
//  DayByDay
//
//  Created by Jerome Campbell on 6/1/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct MultilineTextField: View {
    @Binding var text: String
    @State var isFirstResponder: Bool
    var onCommit: (() -> Void)?
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
        }
    }

    var body: some View {
        let showPlaceholder = self.text.isEmpty && !self.isFirstResponder
        
        return GeometryReader { geometry in
            Button(action: {
                self.isFirstResponder = true
            }) {
                if showPlaceholder {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                                .font(.system(size: 50, weight: .thin))
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    ScrollView {
                        UITextViewWrapper(text: self.internalText,
                                               height: geometry.size.height,
                                               isFirstResponder: self.$isFirstResponder,
                                               onDone: onCommit)
                        .frame(minHeight: geometry.size.height, maxHeight: geometry.size.height)
                    }
                }
            }
            .buttonStyle(ScaleButtonStyle(scaleFactor: showPlaceholder ? 0.8 : 1.0))
        }
    }
}

struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    var height: CGFloat
    @Binding var isFirstResponder: Bool
    var onDone: (() -> Void)?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = false
        textView.text = text
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        if onDone != nil {
            textView.returnKeyType = .done
        }
        if isFirstResponder {
            textView.becomeFirstResponder()
        }
        
        context.coordinator.textView = textView
        textView.delegate = context.coordinator
        textView.layoutManager.delegate = context.coordinator

        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if isFirstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(dynamicHeightTextField: self, isFirstResponder: $isFirstResponder, onDone: onDone)
    }
}

class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate  {
    var dynamicHeightTextField: UITextViewWrapper
    var isFirstResponder: Binding<Bool>
    var onDone: (() -> Void)?
    weak var textView: UITextView?

    init(dynamicHeightTextField: UITextViewWrapper, isFirstResponder: Binding<Bool>, onDone: (() -> Void)? = nil) {
        self.dynamicHeightTextField = dynamicHeightTextField
        self.isFirstResponder = isFirstResponder
        self.onDone = onDone
    }

    func textViewDidChange(_ textView: UITextView) {
        self.dynamicHeightTextField.text = textView.text
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let onDone = self.onDone, text == "\n" {
            self.isFirstResponder.wrappedValue = false
            textView.resignFirstResponder()
            onDone()
            return false
        }
        return true
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager,
                       didCompleteLayoutFor textContainer: NSTextContainer?,
                       atEnd layoutFinishedFlag: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.textView else {
                return
            }
            let size = view.sizeThatFits(view.bounds.size)
            if self?.dynamicHeightTextField.height != size.height {
                self?.dynamicHeightTextField.height = size.height
            }
        }
    }
}
