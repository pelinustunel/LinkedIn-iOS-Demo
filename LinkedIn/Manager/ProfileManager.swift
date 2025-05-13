//
//  ProfileManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 26.04.2025.
//

import Alamofire
import Foundation

class ProfileManager {
    
    static let shared = ProfileManager()
    
    func fetchProfile(token: String, completion: @escaping (Result< ProfileModel, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/user"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: ProfileModel.self) {
                response in
                switch response.result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
