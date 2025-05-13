//
//  SkillViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import RxSwift
import RxCocoa
import Foundation

class SkillViewModel {
    
    let skills = BehaviorRelay<[SkillModel]>(value: [])
    
    func loadSkills() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        SkillManager.shared.fetchSkills(token: token) { result in
            switch result {
            case .success(let skillList):
                self.skills.accept(skillList)
            case .failure(let error):
                print("Skill verileri çekilemedi: \(error)")
            }
        }
    }
    
    func addSkill(name: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(false)
            return
        }
        
        let skillData: [String: Any] = [
            "name": name,
        ]
        
        SkillManager.shared.addSkill(token: token, skillData: skillData) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                print("❌ Skill eklenemedi: \(error)")
                completion(false)
            }
        }
    }
    
    func updateSkill(id: Int, data: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("❌ Token yok")
            completion(false)
            return
        }
        
        print("📡 Güncelleme gönderiliyor, ID: \(id), Data: \(data)")
        
        SkillManager.shared.updateSkill(token: token, skillId: id, skillData: data) { result in
            switch result {
            case .success:
                print("✅ Güncelleme başarılı, veriler tekrar yükleniyor...")
                self.loadSkills()
                completion(true)
            case .failure(let error):
                print("❌ Deneyim güncellenemedi: \(error)")
                completion(false)
            }
        }
    }
    
    func deleteSkill(id: Int, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(false)
            return
        }
        
        SkillManager.shared.deleteSkill(token: token, skillId: id) { result in
            switch result {
            case .success:
                // Local listeyi güncelle
                var current = self.skills.value
                current.removeAll { $0.id == id }
                self.skills.accept(current)
                completion(true)
            case .failure(let error):
                print("❌ Deneyim silinemedi: \(error)")
                completion(false)
            }
        }
    }
    
    
    
}
