//
//  SignInViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 30.11.2024.
//

import UIKit
import RxSwift
import RxCocoa


class SignInViewController : UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.accessibilityIdentifier = "SignIn"
        passwordTextField.isSecureTextEntry = true
        
        let emailObservable = emailTextField.rx.text.orEmpty
        let passwordObservable = passwordTextField.rx.text.orEmpty

        let isFormValid = Observable.combineLatest(emailObservable, passwordObservable) { email, password in
            return !email.isEmpty && !password.isEmpty
        }
        
        // Buton aktif/pasif durumu
        isFormValid
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Renk güncellemesi (aktifse mavi, değilse gri)
        isFormValid
            .subscribe(onNext: { [weak self] isValid in
                   guard let self = self else { return }
                   
                   self.signInButton.backgroundColor = isValid
                       ? UIColor(hex: "#5E9BD9") // Mavi ton örneği
                       : UIColor(hex: "#D3D3D3") // Açık gri örneği

                   self.signInButton.layer.cornerRadius = 10
                   self.signInButton.layer.masksToBounds = true
               })
               .disposed(by: disposeBag)
        
        // Tıklanınca yönlendirme
        signInButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let username = self.emailTextField.text ?? ""
                let password = self.passwordTextField.text ?? ""

                NetworkManager.shared.login(username: username, password: password) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let loginResponse):
                            if let token = loginResponse.token {
                                // ✅ Token varsa kaydet
                                UserDefaults.standard.set(token, forKey: "userToken")
                                UserDefaults.standard.set(loginResponse.user_id, forKey: "userId")
                                print("Token: \(token), User ID: \(loginResponse.user_id)")
                                
                                let mainTabbarController = MainTabBarController()
                                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                    sceneDelegate.window?.rootViewController = mainTabbarController
                                }
                            } else if let errorMessage = loginResponse.error {
                                // ❌ Eğer token yoksa ve error geldiyse
                                self.showAlert(message: errorMessage)
                            } else {
                                // ⚠️ Ne token var ne error → beklenmeyen durum
                                self.showAlert(message: "Bilinmeyen bir hata oluştu.")
                            }
                            
                        case .failure(let error):
                            self.showAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Giriş Başarısız", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
