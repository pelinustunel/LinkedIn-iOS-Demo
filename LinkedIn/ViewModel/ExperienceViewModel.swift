//
//  ExperienceViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//


import RxSwift
import RxCocoa
import Foundation

class ExperienceViewModel {
    
    let experiences = BehaviorRelay<[ExperienceModel]>(value: [])
    
    func loadExperience() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        ExperienceManager.shared.fetchExperience(token: token) { result in
            switch result {
            case .success(let experienceList):
                self.experiences.accept(experienceList)
            case .failure(let error):
                print("Education verileri çekilemedi: \(error)")
            }
        }
    }
    
    
    func addExperience(companyName: String, position: String, experienceYear: String, workMode: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(false)
            return
        }
        
        let experienceData: [String: Any] = [
            "company_name": companyName,
            "position": position,
            "company_logo": "http://127.0.0.1:5003/images/garanti.jpg",
            "experience_year": experienceYear,
            "work_mode": workMode
        ]
        
        ExperienceManager.shared.addExperience(token: token, experiencenData: experienceData) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                print("❌ Deneyim eklenemedi: \(error)")
                completion(false)
            }
        }
    }
    
    func updateExperience(id: Int, data: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("❌ Token yok")
            completion(false)
            return
        }
        
        print("📡 Güncelleme gönderiliyor, ID: \(id), Data: \(data)")
        
        ExperienceManager.shared.updateExperience(token: token, experienceId: id, updatedData: data) { result in
            switch result {
            case .success:
                print("✅ Güncelleme başarılı, veriler tekrar yükleniyor...")
                self.loadExperience()
                completion(true)
            case .failure(let error):
                print("❌ Deneyim güncellenemedi: \(error)")
                completion(false)
            }
        }
    }
    
    func deleteExperience(id: Int, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(false)
            return
        }
        
        ExperienceManager.shared.deleteExperience(token: token, experienceId: id) { result in
            switch result {
            case .success:
                // Local listeyi güncelle
                var current = self.experiences.value
                current.removeAll { $0.id == id }
                self.experiences.accept(current)
                completion(true)
            case .failure(let error):
                print("❌ Deneyim silinemedi: \(error)")
                completion(false)
            }
        }
    }
    
    
}
