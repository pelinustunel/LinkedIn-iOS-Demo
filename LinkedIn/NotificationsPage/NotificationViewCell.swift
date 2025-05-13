//
//  NotificationViewCell.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 10.04.2025.
//

import UIKit

class NotificationViewCell : UITableViewCell {
    
    static let cellIdentifier = "NotificationViewCell"
    
    var notificationId: String? // Silinecek bildirimin id'si buraya atanmalı
    
    var viewModel: NotificationViewModel?
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notificationSettingMiniButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
    }
    
    
    func fillCell(description: String, date: String, image: UIImage, id: Int) {
        descriptionLabel.text = description
        dateLabel.text = date
        profileImage.image = image
        notificationId = String(id) // 🔄 ID'yi atıyoruz
    }
    
    
    @IBAction func notificationDeleteButton(_ sender: Any) {
        guard let parentVC = self.parentViewController else { return }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete notification", style: .destructive, handler: { _ in
            guard let idStr = self.notificationId, let id = Int(idStr) else { return }
            let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
            
            NotificationManager.shared.deleteNotification(id: id, token: token) { success in
                if success {
                    print("✅ Bildirim başarıyla silindi.")
                    self.viewModel?.removeNotificationLocally(id: id) // ✅ şimdi doğru şekilde ViewModel’e bağlı
                } else {
                    print("❌ Bildirim silinemedi.")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        parentVC.present(alert, animated: true)
    }
    
}
