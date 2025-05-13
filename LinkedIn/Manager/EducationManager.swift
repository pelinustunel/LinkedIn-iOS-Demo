//
//  EducationManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import Alamofire
import Foundation


class EducationManager {
    
    static let shared = EducationManager()
    
    func fetchEducations(token: String, completion: @escaping (Result<[EducationModel], Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/education/list"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [EducationModel].self) { response in
                switch response.result {
                case .success(let educations):
                    completion(.success(educations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func addEducation(token: String, educationData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/education/add_education"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: educationData, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func updateEducation(token: String, educationId: Int, educationData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/education/update_education/\(educationId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .put, parameters: educationData, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                if let data = response.data,
                   let responseString = String(data: data, encoding: .utf8) {
                    print("🧾 Response Body: \(responseString)")
                    switch response.result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func deleteEducation(token: String, educationId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/education/delete_education/\(educationId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
