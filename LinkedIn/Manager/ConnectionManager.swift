//
//  ConnectionManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 23.04.2025.
//

import Foundation
import Alamofire

class ConnectionManager {
    
    static let shared = ConnectionManager()
    private init() {}
    
    let baseURL = "https://pelinustunel.store"
    
    func fetchConnection(token: String, completion: @escaping (Result<[ConnectionModel], Error>) -> Void) {
        
        let url = "\(baseURL)/network/list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [ConnectionModel].self) { response in
                switch response.result {
                case .success(let networks):
                    completion(.success(networks))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func addConnection(connection: ConnectionModel, token: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)/network/add_connection"
        
        let parameters: [String: Any] = [
            "id": connection.id,
            "name": connection.name ?? "",
            "job": connection.job ?? "",
            "mutual_connection": connection.mutual_connection ?? "",
            "date": connection.date ?? "",
            "profile_image": connection.profile_image ?? "",
            "isApproved": connection.isApproved ?? true
        ]
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("✅ Bağlantı başarıyla eklendi.")
                    completion(true)
                case .failure(let error):
                    print("❌ Ekleme başarısız: \(error)")
                    completion(false)
                }
            }
    }
    
    
    
    func deleteConnection(name: String, token: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)/network/reject_connection"
        
        let parameters: [String: String] = ["name": name]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("✅ Bağlantı başarıyla silindi.")
                    completion(true)
                case .failure(let error):
                    print("❌ Silme başarısız: \(error)")
                    completion(false)
                }
            }
    }
    
    
}
