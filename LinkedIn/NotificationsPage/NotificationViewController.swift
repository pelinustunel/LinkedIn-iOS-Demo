//
//  NotificationViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 7.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire


class NotificationViewController : UIViewController {
    
    
    @IBOutlet weak var notificationSegment: UISegmentedControl!
    @IBOutlet weak var notificationTableView: UITableView!
    
    let disposeBag = DisposeBag()
    private let viewModel = NotificationViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.fetchNotifications()
        setupTableView()
        bindTableView()
        bindErrorHandling()
        
        
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "NotificationViewCell", bundle: nil)
        notificationTableView.register(nib, forCellReuseIdentifier: "NotificationViewCell")
        notificationTableView.reloadData()
        
    }
    
    private func bindTableView() {
        viewModel.notifications
            .bind(to: notificationTableView.rx.items(cellIdentifier: "NotificationViewCell", cellType: NotificationViewCell.self)) { index, notification, cell in
                
                cell.viewModel = self.viewModel // ✅ burada geçiyoruz
                cell.descriptionLabel.text = notification.message
                cell.dateLabel.text = notification.timestamp
                cell.notificationId = String(notification.notification_id) // 👈 BURASI YENİ!
                
                // Profil resmi yükleniyor
                if let profileURLString = notification.notification_image,
                   let profileURL = URL(string: profileURLString) {
                    URLSession.shared.dataTask(with: profileURL) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.profileImage.image = image
                            }
                        }
                    }.resume()
                } else {
                    cell.profileImage.image = UIImage(named: "profile")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindErrorHandling() {
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
}
