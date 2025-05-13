//
//  ProfileManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import Foundation
import Alamofire

class ActivityManager {
    
    static let shared = ActivityManager()
    
    func fetchActivities(token: String, completion: @escaping (Result<[ActivityModel], Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/activity/list"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [ActivityModel].self) { response in
                switch response.result {
                case .success(let activities):
                    completion(.success(activities))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
