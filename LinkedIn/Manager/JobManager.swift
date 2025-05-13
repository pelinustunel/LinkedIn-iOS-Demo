//
//  JobManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 23.04.2025.
//

import Foundation
import Alamofire

class JobManager {
    
    static let shared = JobManager()
    private init() {}
    
    let baseURL = "http://127.0.0.1:5003"
    
    func fetchJob(token: String, completion: @escaping (Result<[JobModel], Error>) -> Void) {
        
        let url = "\(baseURL)/job/list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [JobModel].self) { response in
                switch response.result {
                case .success(let jobs):
                    completion(.success(jobs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
