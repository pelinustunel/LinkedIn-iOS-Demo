//
//  ProfileViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 26.04.2025.
//

import RxSwift
import RxCocoa
import Foundation

class ProfileViewModel {
    
    let user = BehaviorRelay<ProfileModel?>(value: nil)
    
    func loadProfile() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        ProfileManager.shared.fetchProfile(token: token) { result in
            switch result {
            case .success(let profile):
                self.user.accept(profile)
            case .failure(let error):
                print("Profile verileri çekilemedi \(error)")
            }
        }
        
    }
    
}
