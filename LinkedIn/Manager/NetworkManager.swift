//
//  NetworkManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 20.04.2025.
//

import Foundation
import Alamofire



// Singleton NetworkManager
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "https://pelinustunel.store"  // Gerçek sunucu adresinizle değiştirin
    
    // 🔐 Giriş işlemi
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = "\(baseURL)/login/"
        let params = LoginRequest(username: username, password: password)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if let token = loginResponse.token {
                        UserDefaults.standard.set(token, forKey: "userToken")
                        
                        // Refresh token backend'den dönüyorsa burada eklenebilir (örnek)
                        if let refreshToken = loginResponse.refresh_token {
                            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        }
                        
                        UserDefaults.standard.set(loginResponse.user_id, forKey: "userId")
                        completion(.success(loginResponse))
                    } else {
                        completion(.failure(NSError(domain: "", code: 401, userInfo: [
                            NSLocalizedDescriptionKey: loginResponse.error ?? "Giriş başarısız."])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 🧾 Kayıt işlemi
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
    
    // 🔁 Refresh token işlemi
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            completion(false)
            return
        }
        
        let url = "\(baseURL)/login/refresh"
        let parameters = ["refresh_token": refreshToken]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate()
        .responseDecodable(of: TokenResponse.self) { response in
            switch response.result {
            case .success(let tokenResponse):
                UserDefaults.standard.set(tokenResponse.token, forKey: "userToken")
                print("✅ Yeni token alındı: \(tokenResponse.token)")
                completion(true)
            case .failure(let error):
                print("❌ Refresh token başarısız: \(error)")
                completion(false)
            }
        }
    }
    
    // 🌐 Token kontrollü istek (JSON döndürmeyen basit API çağrısı için)
    func makeAuthenticatedRequest(to endpoint: String,
                                  method: HTTPMethod,
                                  parameters: Parameters? = nil,
                                  completion: @escaping (DataResponse<Data?, AFError>) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("❌ Access token yok")
            return
        }
        
        let url = "\(baseURL)\(endpoint)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                if response.response?.statusCode == 401 {
                    print("⚠️ Token süresi dolmuş. Yenileme deneniyor...")
                    
                    self.refreshAccessToken { success in
                        if success {
                            self.makeAuthenticatedRequest(to: endpoint, method: method, parameters: parameters, completion: completion)
                        } else {
                            print("🚫 Token yenileme başarısız. Kullanıcıyı login ekranına yönlendirin.")
                        }
                    }
                } else {
                    completion(response)
                }
            }
    }
}
