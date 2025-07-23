//
//  MessageManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 23.04.2025.
//

import Foundation
import Alamofire

class MessageManager {
    
    static let shared = MessageManager()
    private init() {}
    
    /// 🔥 Conversation listesi (son mesajlar, kişilerle olan konuşmalar)
    func fetchMessages(token: String, userId: String, completion: @escaping (Result<[ConversationModel], Error>) -> Void) {
        let url = "https://pelinustunel.store/message/list"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let parameters: [String: Any] = ["user_id": userId]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: [ConversationModel].self) { response in
                switch response.result {
                case .success(let conversations):
                    completion(.success(conversations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// 🟣 Mesaj detayını getirir (tek mesaj)
    func fetchMessageDetail(token: String, messageId: Int, completion: @escaping (Result<MessageModel, Error>) -> Void) {
        let url = "https://127.0.0.1:5003/message/\(messageId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: MessageModel.self) { response in
                switch response.result {
                case .success(let message):
                    completion(.success(message))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    /// 🟢 İki kullanıcı arasındaki tüm sohbet geçmişini getirir
    func fetchChatHistory(token: String, currentUserId: String, otherUserId: String, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        let url = "https://127.0.0.1:5003/message/detail"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let parameters: [String: Any] = [
            "current_user_id": currentUserId,
            "other_user_id": otherUserId
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: [MessageModel].self) { response in
                switch response.result {
                case .success(let messageList):
                    completion(.success(messageList))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
