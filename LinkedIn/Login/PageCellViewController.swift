//
//  PageCellViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 29.11.2024.
//

import UIKit
import Lottie

class PageCellViewController: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: PageCellViewController.self)
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var animation: LottieAnimationView?  // LottieAnimationView kullanılmalı
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configureCell(page: Page) {
        // Animasyonu ayarla
        animation = LottieAnimationView(name: page.animationName)
        animation?.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height * 0.7)
        animation?.animationSpeed = 1
        animation?.loopMode = .loop
        animation?.play()
        
        if let animation = animation {
            containerView.addSubview(animation)
        }
        
        // TextView'i ayarla
        textView.text = page.description
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.frame = CGRect(x: 0, y: containerView.frame.height * 0.7, width: self.containerView.frame.width, height: self.containerView.frame.height * 0.3)
    }
    
}
