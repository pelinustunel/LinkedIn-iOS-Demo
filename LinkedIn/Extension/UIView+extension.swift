//
//  UIView+extension.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 8.05.2025.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let vc = responder as? UIViewController {
                return vc
            }
        }
        return nil
    }
}
