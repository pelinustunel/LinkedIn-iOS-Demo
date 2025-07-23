//
//  SecureNetworkManager.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 16.05.2025.
//

import Foundation
import Alamofire

final class SecureNetworkManager {
    
    static let shared = SecureNetworkManager()

    private let baseURL = "https://pelinustunel.store"
    private let session: Session

    private init() {
        session = NetworkSessionFactory.createSession(
            for: "www.pelinsuperapp.com",
            pinning: .certificate(certName: "pelinustunel.store") // 🛡️ .publicKey(certName: "MyServer") da olabilir
        )
    }

    func callSecureGET(endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        session.request(url, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }

    func callSecurePOST<T: Encodable, R: Decodable>(
        endpoint: String,
        parameters: T,
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        let url = "\(baseURL)\(endpoint)"
        session.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: R.self) { response in
                switch response.result {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
}
