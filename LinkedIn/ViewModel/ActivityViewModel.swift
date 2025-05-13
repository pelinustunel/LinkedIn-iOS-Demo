//
//  ActivityViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

import RxSwift
import RxCocoa
import Foundation

class ActivityViewModel {
    let activities = BehaviorRelay<[ActivityModel]>(value: [])
    let disposeBag = DisposeBag()
    
    func loadActivities() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        ActivityManager.shared.fetchActivities(token: token) { [weak self] result in
            switch result {
            case .success(let activityList):
                self?.activities.accept(activityList)
            case .failure(let error):
                print("Aktiviteler çekilemedi: \(error)")
            }
        }
    }
}
