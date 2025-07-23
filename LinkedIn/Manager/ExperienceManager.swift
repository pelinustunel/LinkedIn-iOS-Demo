//
//  ExperienceManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import Alamofire
import Foundation


class ExperienceManager {
    
    static let shared = ExperienceManager()
    
    func fetchExperience(token: String, completion: @escaping (Result<[ExperienceModel], Error>) -> Void) {
        let url = "https://pelinustunel.store/profile/experience/list"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [ExperienceModel].self) { response in
                switch response.result {
                case .success(let experiences):
                    completion(.success(experiences))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func addExperience(token: String, experiencenData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://127.0.0.1:5003/profile/experience/add_experience"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: experiencenData, encoding: JSONEncoding.default, headers: headers)
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
    
    func updateExperience(token: String, experienceId: Int, updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://127.0.0.1:5003/profile/experience/update_experience/\(experienceId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .put, parameters: updatedData, encoding: JSONEncoding.default, headers: headers)
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
    
    func deleteExperience(token: String, experienceId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://127.0.0.1:5003/profile/experience/delete_experience/\(experienceId)"
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
