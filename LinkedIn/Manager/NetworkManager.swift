//
//  NetworkManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 20.04.2025.
//

import Foundation
import Alamofire


class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "http://127.0.0.1:5003"
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = "\(baseURL)/login/"
        let params = LoginRequest(username: username, password: password)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if loginResponse.token != nil {
                        completion(.success(loginResponse)) 
                    } else {
                        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: loginResponse.error ?? "Giriş başarısız."])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func registerUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/register"
        let params = RegisterRequest(firstName: firstName, lastName: lastName, email: email, password: password)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let res):
                    if let errorMessage = res.error {
                        completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    } else {
                        completion(.success(res.message))
                    }
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
    
   
    
}
