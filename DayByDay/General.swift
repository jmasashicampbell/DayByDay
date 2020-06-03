//
//  General.swift
//  DayByDay
//
//  Created by Jerome Campbell on 5/9/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


// MARK: Functions

/**
  Converts a filename to a URL
  - Parameter filename: The filename to convert
  - Returns: The URL of the file in the main bundle
 */

func bundleUrlFromFilename(_ filename: String) -> URL {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find file in main bundle.")
    }
    return file
}


/**
  Loads a JSON object from a file
  - Parameter file: The file from which to load
  - Returns: The loaded object
 */

func load<T: Decodable>(_ file: URL) throws -> T {
    let data = try Data(contentsOf: file)
    
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse file as \(T.self):\n\(error)")
    }
}


/**
  Converts a DateComponents object to a string date representation with the provided format.
  - Parameter dateComponents: The DateComponents object to be converted
  - Parameter format: The format with which to convert
  - Returns: The converted date string
 */

func dateComponentsToString(_ dateComponents: DateComponents, format: String) -> String {
    let date = Calendar.current.date(from: dateComponents)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date!)
}


/**
  Converts a Date to a DateComponents object with year, month, and day components.
 */
func makeComponents(date: Date) -> DateComponents {
    return Calendar.current.dateComponents([.year, .month, .day], from: date)
}


// MARK: Extensions


/**
  Rotates a view by 180 degrees and reflects it across the horizontal axis.
  Used to make a ScrollView start from the opposite side.
 */
extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: 1, y: -1, anchor: .center)
    }
}

/**
  Enables comparison of DateComponents
 */
extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year! < rhs.year!
        } else if lhs.month! != rhs.month! {
            return lhs.month! < rhs.month!
        } else {
            return lhs.day! < rhs.day!
        }
    }
}


/**
  Publishes keyboard height when the keyboard is shown or hidden.
  Used to intelligently move TextField so it is not obscured by keyboard.
 */
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

/**
 Publishes keyboard height when the keyboard is shown or hidden.
 Used to intelligently move TextField so it is not obscured by keyboard.
*/
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}


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


// MARK: Structs

struct NotificationsToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
            Spacer()
            Button(action: { withAnimation { configuration.isOn.toggle() } } ) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
    }
}


/**
  Makes a view
 */
struct KeyboardAdaptive: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            }
            // 6.
            .animation(.easeOut(duration: 0.16))
        }
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
      
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
      
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}


struct ScaleButtonStyle: ButtonStyle {
    var scaleFactor: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleFactor : 1)
            .animation(.easeIn(duration: 0.08))
    }
}

