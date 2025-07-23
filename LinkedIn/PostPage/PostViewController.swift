//
//  PostPageController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseCrashlytics
import Firebase

class PostViewController : UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var postApplyButton: UIButton!
    @IBOutlet weak var postExitButton: UIButton!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var imageAddButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Başlangıçta buton pasif ve gri
        postApplyButton.isEnabled = false
        postApplyButton.backgroundColor = UIColor(hex: "#D3D3D3")
        postApplyButton.layer.cornerRadius = 8
        
        // Email girildiğinde buton aktif hale gelsin
        detailTextView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isValid in
                self?.postApplyButton.isEnabled = isValid
                self?.postApplyButton.backgroundColor = isValid ? UIColor(hex: "#5E9BD9") : UIColor(hex: "#D3D3D3")
            })
            .disposed(by: disposeBag)
        
        
        postExitButton.accessibilityIdentifier = "Exit"
        detailTextView.accessibilityIdentifier = "PostTextView"
        
        postProfileImage.layer.cornerRadius = postProfileImage.frame.height / 2
        postProfileImage.clipsToBounds = true
        
        detailTextView.delegate = self
        detailTextView.text = "What do you want to talk about?"
        detailTextView.textColor = .lightGray
        
        detailTextView.isEditable = true
        detailTextView.isSelectable = true
        detailTextView.isUserInteractionEnabled = true
        detailTextView.isScrollEnabled = true
        
        postImageView.isHidden = true
        
        
    }
    
    
    //    textView is cleared when textView is clicked
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What do you want to talk about?" {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    //    textview message ends and placeholder returns again
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "What do you want to talk about?"
            textView.textColor = .lightGray
        }
    }
    
    
    
    @IBAction func postAddClick(_ sender: Any) {
        guard let content = detailTextView.text,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            Crashlytics.crashlytics().log("⚠️ Token veya içerik eksik")
            return
        }
        
        // 📌 Firebase'e log gönder: kullanıcı post atmaya çalışıyor
        Crashlytics.crashlytics().log("📝 Post ekleniyor: \(content)")
        
        // ❗️Opsiyonel: Test için manuel crash örneği
        // Uncomment edip test edebilirsin
        // fatalError("🔥 Post eklenirken crash testi")
        
        PostManager.shared.addPost(token: token, content: content, image: postImageView.image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    Crashlytics.crashlytics().log("✅ Post başarıyla eklendi")
                    
                    NotificationCenter.default.post(name: .postAdded, object: nil)
                    
                    // Ana sayfaya dön
                    if let tabBarController = self?.presentingViewController as? UITabBarController {
                        tabBarController.selectedIndex = 0
                    }
                    
                    self?.dismiss(animated: true)
                    
                case .failure(let error):
                    // ❗️Firebase’e hata kaydı
                    Crashlytics.crashlytics().record(error: error)
                    print("❌ Post eklenemedi: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    @IBAction func postExitClick(_ sender: Any) {
        if let tabBarController = self.presentingViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            postImageView.image = selectedImage
            postImageView.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
