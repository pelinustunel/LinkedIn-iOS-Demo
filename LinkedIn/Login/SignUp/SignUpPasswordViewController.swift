//
//  SignUpPassword.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpPasswordViewController : UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var checkBox: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Email gösterimi için UserDefaults’tan al
                if let email = UserDefaults.standard.string(forKey: "email") {
                    emailTextField.text = email
                }

                checkBox.setImage(UIImage(systemName: "square"), for: .normal)
                checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
                checkBox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

                continueButton.isEnabled = false
                continueButton.backgroundColor = UIColor(hex: "#D3D3D3")
                continueButton.layer.cornerRadius = 8

                // Password girildiğinde buton aktif hale gelsin
                passwordTextField.rx.text.orEmpty
                    .map { !$0.isEmpty }
                    .distinctUntilChanged()
                    .subscribe(onNext: { [weak self] isValid in
                        self?.continueButton.isEnabled = isValid
                        self?.continueButton.backgroundColor = isValid ? UIColor(hex: "#5E9BD9") : UIColor(hex: "#D3D3D3")
                    })
                    .disposed(by: disposeBag)
        
    }
   

   
    @objc func toggleCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text,
                      let email = UserDefaults.standard.string(forKey: "email"),
                      let firstName = UserDefaults.standard.string(forKey: "first_name"),
                      let lastName = UserDefaults.standard.string(forKey: "last_name") else {
                    showAlert(message: "Eksik bilgi. Lütfen tüm alanları doldurun.")
                    return
                }

                NetworkManager.shared.registerUser(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let msg):
                            print("✅ Register başarılı: \(msg)")
                            let mainTabbarController = MainTabBarController()
                            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                sceneDelegate.window?.rootViewController = mainTabbarController
                            }
                        case .failure(let error):
                            self.showAlert(message: error.localizedDescription)
                        }
                    }
                }
    }
    
    func showAlert(message: String) {
          let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
          present(alert, animated: true)
      }
    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
}
