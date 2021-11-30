//
//  UITextField+Publisher.swift
//  BeersDemo
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text) // Get non optional text
            .eraseToAnyPublisher()
    }
}
