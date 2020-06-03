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
    @State private var viewHeight: CGFloat = 40
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
        }
    }

    var body: some View {
        let showPlaceholder = self.text.isEmpty && !self.isFirstResponder
        
        return Button(action: {
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
                                      calculatedHeight: $viewHeight,
                                      isFirstResponder: self.$isFirstResponder,
                                      onDone: onCommit)
                    .frame(minHeight: viewHeight, maxHeight: viewHeight)
                }
            }
        }
        .buttonStyle(ScaleButtonStyle(scaleFactor: showPlaceholder ? 0.8 : 1.0))
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
        textField.textColor = UIColor.white
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
        if isFirstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
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
        return Coordinator(text: $text, height: $calculatedHeight, isFirstResponder: $isFirstResponder, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var isFirstResponder: Binding<Bool>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, isFirstResponder: Binding<Bool>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.isFirstResponder = isFirstResponder
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
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
    }
}
