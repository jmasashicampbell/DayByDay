//
//  GeneralMainApp.swift
//  DayByDay
//
//  Created by Jerome Campbell on 1/23/22.
//  Copyright © 2022 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI


/**
 Used to find first responder text field
 */
extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
