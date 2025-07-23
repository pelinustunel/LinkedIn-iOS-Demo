//
//  PostManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 21.04.2025.
//

import Foundation
import Alamofire
import UIKit

class PostManager {
    
    static let shared = PostManager()
    private init() {}
    
    let baseURL = "https://pelinustunel.store"
    
    func fetchPosts(token: String, completion: @escaping (Result<[PostModel], Error>) -> Void) {
        let url = "\(baseURL)/post/list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [PostModel].self) { response in
                switch response.result {
                case .success(let posts):
                    completion(.success(posts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func addPost(token: String, content: String, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/post/add_post"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        // 🔹 userID'yi UserDefaults'tan al
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            completion(.failure(NSError(domain: "UserIDError", code: 401, userInfo: [NSLocalizedDescriptionKey: "userID bulunamadı."])))
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(content.utf8), withName: "content")
            multipartFormData.append(Data(userId.utf8), withName: "user_id")  // ✅ Buraya düzeltme geldi
            
            if let image = image, let imageData = image.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(imageData, withName: "image", fileName: "photo.jpg", mimeType: "image/jpeg")
            }
        }, to: url, headers: headers)
        .validate()
        .response { response in
            debugPrint("🔴 Response:", response)
            
            if let data = response.data,
               let responseString = String(data: data, encoding: .utf8) {
                print("📨 Response body:", responseString)
            }
            
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
