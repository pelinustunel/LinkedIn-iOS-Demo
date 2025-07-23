//
//  NetworkSessionFactory.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 16.05.2025.
//

enum PinningType {
    case certificate(certName: String)
    case publicKey(certName: String)
    case none
}

import Foundation
import Alamofire

final class NetworkSessionFactory {
    
    static func createSession(for host: String, pinning: PinningType) -> Session {
        let evaluators: [String: ServerTrustEvaluating]
        
        switch pinning {
        case .certificate(let certName):
            guard let certificate = loadCertificate(named: certName) else {
                fatalError("❌ Sertifika bulunamadı: \(certName)")
            }
            
            evaluators = [
                host: PinnedCertificatesTrustEvaluator(
                    certificates: [certificate],
                    acceptSelfSignedCertificates: false, // Sadece geliştirme için true yapın
                    performDefaultValidation: true,     // Production'da mutlaka true olmalı
                    validateHost: true
                )
            ]
            
        case .publicKey(let certName):
            guard let publicKey = loadPublicKey(named: certName) else {
                fatalError("❌ Public key bulunamadı: \(certName)")
            }
            
            evaluators = [
                host: PublicKeysTrustEvaluator(
                    keys: [publicKey],
                    performDefaultValidation: true,
                    validateHost: true
                )
            ]
            
        case .none:
            evaluators = [:]
        }
        
        let configuration = URLSessionConfiguration.af.default
        return Session(
            configuration: configuration,
            serverTrustManager: ServerTrustManager(evaluators: evaluators))
    }

    private static func loadCertificate(named name: String) -> SecCertificate? {
        guard let path = Bundle.main.path(forResource: name, ofType: "cer"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
              let cert = SecCertificateCreateWithData(nil, data) else {
            return nil
        }
        return cert
    }

    private static func loadPublicKey(named name: String) -> SecKey? {
        guard let path = Bundle.main.path(forResource: name, ofType: "cer"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
              let cert = SecCertificateCreateWithData(nil, data) else {
            return nil
        }

        var trust: SecTrust?
        let policy = SecPolicyCreateBasicX509()
        let status = SecTrustCreateWithCertificates(cert, policy, &trust)

        guard let trust = trust, status == errSecSuccess else { return nil }
        return SecTrustCopyKey(trust)
    }
}
