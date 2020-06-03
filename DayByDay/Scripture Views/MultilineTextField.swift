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
    private var onCommit: (() -> Void)?
    @Binding private var text: String
    @Binding private var isFirstResponder: Bool
    @State private var viewHeight: CGFloat = 40
    @State private var shouldShowPlaceholder = false
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.shouldShowPlaceholder = $0.isEmpty
        }
    }

    var body: some View {
        Group {
            if shouldShowPlaceholder {
                Button(action: {
                    self.isFirstResponder = true
                    self.shouldShowPlaceholder = false
                }) {
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
                }
                .buttonStyle(ScaleButtonStyle(scaleFactor: 0.8))
            } else {
                ScrollView {
                    UITextViewWrapper(text: self.internalText,
                                      calculatedHeight: $viewHeight,
                                      isFirstResponder: self.$isFirstResponder,
                                      onDone: onCommit)
                    .frame(minHeight: viewHeight, maxHeight: viewHeight)
                    //.background(placeholderView)
                }
            }
        }
    }

    
    init (text: Binding<String>, isFirstResponder: Binding<Bool>, onCommit: (() -> Void)? = nil) {
        self.onCommit = onCommit
        self._text = text
        self._isFirstResponder = isFirstResponder
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty && !self.isFirstResponder)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    @Binding var isFirstResponder: Bool
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        if isFirstResponder {
            textField.becomeFirstResponder()
        }
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // call in next render cycle.
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }
}
