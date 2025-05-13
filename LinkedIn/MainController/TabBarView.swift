//
//  TabBarView.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.04.2025.
//

import UIKit

class TopBarView: UIView {
    
    var onChatButtonTapped: (() -> Void)?  // callback
    var onProfileTapped: (() -> Void)?
    
    
    let imageView = UIImageView()
    let textField = UITextField()
    let chatButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        chatButton.accessibilityIdentifier = "chatButton"
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor(hex: "#21293A")
        
        imageView.image = UIImage(named: "profile")
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        textField.placeholder = "Search..."
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        chatButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        chatButton.tintColor = .white
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        
        addSubview(imageView)
        addSubview(textField)
        addSubview(chatButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 36),
            
            chatButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            chatButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chatButton.widthAnchor.constraint(equalToConstant: 32),
            chatButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc private func chatButtonTapped() {
        onChatButtonTapped?()
    }
    @objc private func profileTapped() {
        onProfileTapped?()
    }
    
}
