//
//  showAlert+extension.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Uyarı", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

