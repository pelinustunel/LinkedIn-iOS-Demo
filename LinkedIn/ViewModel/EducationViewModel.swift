//
//  EducationViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import RxSwift
import RxCocoa
import Foundation

class EducationViewModel {
    let educations = BehaviorRelay<[EducationModel]>(value: [])
    
    func loadEducations() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        EducationManager.shared.fetchEducations(token: token) { result in
            switch result {
            case .success(let educationList):
                self.educations.accept(educationList)
            case .failure(let error):
                print("Education verileri çekilemedi: \(error)")
            }
        }
    }
    
    func addEducation(school: String, degree: String, fieldOfStudy: String, educationYear: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(false)
            return
        }
        
        let educationData: [String: Any] = [
            "school": school,
            "degree": degree,
            "education_image": "http://127.0.0.1:5003/images/kirklareli.jpg", // default image
            "field_of_study": fieldOfStudy,
            "education_year": educationYear
        ]
        
        EducationManager.shared.addEducation(token: token, educationData: educationData) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                print("❌ Eğitim eklenemedi: \(error)")
                completion(false)
            }
        }
    }
    
    func updateEducation(id: Int, data: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            print ("Token Yok")
            completion(false)
            return
        }
        
        print("📡 Güncelleme gönderiliyor, ID: \(id), Data: \(data)")
        
        EducationManager.shared.updateEducation(token: token, educationId: id, educationData: data) { result in
            switch result {
            case .success:
                print("✅ Güncelleme başarılı, veriler tekrar yükleniyor...")
                self.loadEducations()
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
        
        EducationManager.shared.deleteEducation(token: token, educationId: id) { result in
            switch result {
            case .success:
                // Local listeyi güncelle
                var current = self.educations.value
                current.removeAll { $0.id == id }
                self.educations.accept(current)
                completion(true)
            case .failure(let error):
                print("❌ Deneyim silinemedi: \(error)")
                completion(false)
            }
        }
    }
    
}
