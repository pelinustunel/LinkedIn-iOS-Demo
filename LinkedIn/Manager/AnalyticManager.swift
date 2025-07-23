//
//  AnalyticManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//


import Alamofire
import Foundation

class AnalyticManager {
    
    static let shared = AnalyticManager()
    
    func fetchAnalytics(token: String, completion: @escaping(Result<[AnalyticModel], Error>) -> Void) {
        
        let url = "https://pelinustunel.store/profile/analytic/list"  // Gerçek sunucu adresinizle değiştirin
        

        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [AnalyticModel].self) { response in
                switch response.result {
                case .success(let analytics):
                    completion(.success(analytics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
}
