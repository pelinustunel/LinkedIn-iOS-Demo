//
//  SignUpEmailViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpEmailViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    private let disposeBag = DisposeBag()

        override func viewDidLoad() {
            super.viewDidLoad()

            // Başlangıçta buton pasif ve gri
            continueButton.isEnabled = false
            continueButton.backgroundColor = UIColor(hex: "#D3D3D3")
            continueButton.layer.cornerRadius = 8

            // Email girildiğinde buton aktif hale gelsin
            emailTextField.rx.text.orEmpty
                .map { !$0.isEmpty }
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] isValid in
                    self?.continueButton.isEnabled = isValid
                    self?.continueButton.backgroundColor = isValid ? UIColor(hex: "#5E9BD9") : UIColor(hex: "#D3D3D3")
                })
                .disposed(by: disposeBag)
        }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
            
            // Email'i kaydet
            UserDefaults.standard.set(email, forKey: "email")

            let signUpPasswordVC = SignUpPasswordViewController(nibName: "SignUpPassword", bundle: nil)
            signUpPasswordVC.modalPresentationStyle = .overFullScreen
            signUpPasswordVC.view.frame.origin.y = self.view.frame.size.height

            self.present(signUpPasswordVC, animated: false) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    signUpPasswordVC.view.frame.origin.y = 0
                }, completion: nil)
            }
    }
    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
