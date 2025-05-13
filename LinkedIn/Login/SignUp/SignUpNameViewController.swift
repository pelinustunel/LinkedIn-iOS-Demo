//
//  SignUpViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpNameViewController : UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nameContinueButton: UIButton!
    
    
    private let disposeBag = DisposeBag()

        override func viewDidLoad() {
            super.viewDidLoad()

            // Başlangıçta buton pasif ve gri
            nameContinueButton.isEnabled = false
            nameContinueButton.backgroundColor = UIColor(hex: "#D3D3D3")
            nameContinueButton.layer.cornerRadius = 8

            // First Name girildiğinde buton aktif hale gelsin
            firstNameTextField.rx.text.orEmpty
                .map { !$0.isEmpty }
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] isValid in
                    self?.nameContinueButton.isEnabled = isValid
                    self?.nameContinueButton.backgroundColor = isValid ? UIColor(hex: "#5E9BD9") : UIColor(hex: "#D3D3D3")
                })
                .disposed(by: disposeBag)
        }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        // Kullanıcıdan alınan isim ve soyismi sakla
         let firstName = firstNameTextField.text ?? ""
         let lastName = lastNameTextField.text ?? ""
         
         UserDefaults.standard.set(firstName, forKey: "first_name")
         UserDefaults.standard.set(lastName, forKey: "last_name")
         
         // Sonraki adıma geç
         let signUpEmailVC = SignUpEmailViewController(nibName: "SignUpEmail", bundle: nil)
         signUpEmailVC.modalPresentationStyle = .overFullScreen
         signUpEmailVC.view.frame.origin.y = self.view.frame.size.height
         self.present(signUpEmailVC, animated: false) {
             UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                 signUpEmailVC.view.frame.origin.y = 0
             }, completion: nil)
         }
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
