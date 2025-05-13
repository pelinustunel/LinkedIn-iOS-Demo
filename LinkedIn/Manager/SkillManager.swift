//
//  SkillManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import Alamofire
import Foundation

class SkillManager {
    
    static let shared = SkillManager()
    
    func fetchSkills(token: String, completion: @escaping(Result<[SkillModel], Error>) -> Void) {
        
        let url = "http://127.0.0.1:5003/profile/skill/list"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [SkillModel].self) { response in
                switch response.result {
                case .success(let skills):
                    completion(.success(skills))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
    func addSkill(token: String, skillData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/skill/add_skill"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: skillData, encoding: JSONEncoding.default, headers: headers)
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
    
    func updateSkill(token: String, skillId: Int, skillData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/skill/update_skill/\(skillId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .put, parameters: skillData, encoding: JSONEncoding.default, headers: headers)
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
    
    func deleteSkill(token: String, skillId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://127.0.0.1:5003/profile/skill/delete_skill/\(skillId)"
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

