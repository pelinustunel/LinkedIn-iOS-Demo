//
//  AnalyticViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//

import RxSwift
import RxCocoa
import Foundation

class AnalyticViewModel {
    
    let analytics = BehaviorRelay<[AnalyticModel]>(value: [])
    
    func loadAnalytics() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        AnalyticManager.shared.fetchAnalytics(token: token) { result in
            switch result {
            case .success(let analyticList):
                self.analytics.accept(analyticList)
            case .failure(let error):
                print("Analytic verileri çekilemedi: \(error)")
            }
        }
    }
}
