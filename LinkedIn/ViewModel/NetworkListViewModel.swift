//
//  Untitled.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkListViewModel {
    
    let networkLists = BehaviorRelay<[ConnectionModel]>(value: [])
    let errorMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    func fetchNetworkLists() {
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            errorMessage.accept("Token bulunamadı")
            return
        }
        
        ConnectionManager.shared.fetchConnection(token: token) { [weak self] result in
            
            switch result {
            case .success(let networkConnectionList):
                self?.networkLists.accept(networkConnectionList)
            case .failure(let error):
                self?.errorMessage.accept("Network Connection Listi çekilemedi: \(error.localizedDescription)")
            }
        }
    }
    
    func addConnection(connection: ConnectionModel) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            errorMessage.accept("Token bulunamadı")
            return
        }
        
        ConnectionManager.shared.addConnection(connection: connection, token: token) { [weak self] success in
            if success {
                print("✅ Ekleme başarılı")
                self?.removeConnectionLocally(by: connection.id) // ❗️liste güncelleniyor
            } else {
                self?.errorMessage.accept("Bağlantı eklenemedi")
            }
        }
    }
    
    
    
    func deleteConnection(name: String) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            errorMessage.accept("Token bulunamadı")
            return
        }
        
        ConnectionManager.shared.deleteConnection(name: name, token: token) { [weak self] success in
            if success {
                print("✅ Silme başarılı")
                if let id = self?.networkLists.value.first(where: { $0.name == name })?.id {
                    self?.removeConnectionLocally(by: id)
                }
            } else {
                self?.errorMessage.accept("Silme işlemi başarısız")
            }
        }
    }
    
    
    func removeConnectionLocally(by id: Int) {
        var current = networkLists.value
        current.removeAll { $0.id == id }
        networkLists.accept(current)
    }
    
}
