//
//  NotificationManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 21.04.2025.
//

import Foundation
import Alamofire

class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    let baseURL = "http://127.0.0.1:5003"
    
    
    func fetchNotifications(token: String, completion: @escaping (Result<[NotificationModel], Error>) -> Void) {
        let url = "\(baseURL)/notification/list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [NotificationModel].self) { response in
                switch response.result {
                case .success(let notifications):
                    completion(.success(notifications))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Notification Delete
    func deleteNotification(id: Int, token: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)/notification/\(id)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("✅ Bildirim silindi.")
                    completion(true)
                case .failure(let error):
                    print("❌ Silme işlemi başarısız: \(error)")
                    completion(false)
                }
            }
    }
    
}
