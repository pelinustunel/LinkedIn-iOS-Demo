//
//  Untitled.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 23.05.2025.
//

import Alamofire
import Foundation

class PipedreamAPIManager {
    static let shared = PipedreamAPIManager()
    
    let session: Session
    
    private init() {
        // Önce sertifikaları al
        let certificates = PipedreamAPIManager.loadCertificates()
        
        // Sonra session'ı oluştur
        let trustPolicy = PinnedCertificatesTrustEvaluator(certificates: certificates)
        
        let configuration = URLSessionConfiguration.af.default
        session = Session(
            configuration: configuration,
            serverTrustManager: ServerTrustManager(evaluators: [
                "pipedream.com": trustPolicy,
                "*.m.pipedream.net": trustPolicy,
                "eoo2uzzr5brnkph.m.pipedream.net": trustPolicy
            ])
        )
    }
    
    // Static metod olarak tanımla, böylece instance oluşturmadan çağrılabilir
    private static func loadCertificates() -> [SecCertificate] {
        guard let certificateUrl = Bundle.main.url(forResource: "pipedream", withExtension: "cer"),
              let certificateData = try? Data(contentsOf: certificateUrl),
              let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) else {
            fatalError("Pipedream sertifikası bulunamadı!")
        }
        return [certificate]
    }
    
    func makeRequest(completion: @escaping (Result<Data, Error>) -> Void) {
        session.request("https://eoo2uzzr5brnkph.m.pipedream.net").response { response in
            switch response.result {
            case .success(let data):
                completion(.success(data ?? Data()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
                
            }
        }
    }
}
