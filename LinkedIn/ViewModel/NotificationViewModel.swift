//
//  NotificationViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

class NotificationViewModel {
    
    let notifications = BehaviorRelay<[NotificationModel]>(value: [])
    let errorMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    static let shared = NotificationViewModel() 
    
    func fetchNotifications() {
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            errorMessage.accept("Token bulunamadı")
            return
        }
        
        NotificationManager.shared.fetchNotifications(token: token) { [weak self] result in
            switch result {
            case .success(let notificationList):
                self?.notifications.accept(notificationList)
            case .failure(let error):
                self?.errorMessage.accept("Notification çekilemedi: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotificationLocally(id: Int) {
        var current = notifications.value
        current.removeAll { $0.notification_id == id }
        notifications.accept(current)
    }
    
}
