//
//  JobViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

class JobViewModel {
    let jobs = BehaviorRelay<[JobModel]>(value: [])
    let errorMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    func fetchJobs() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            errorMessage.accept("Token bulunamadı")
            return
        }
        
        JobManager.shared.fetchJob(token: token) { [weak self] result in
            switch result {
            case .success(let jobList):
                self?.jobs.accept(jobList)
            case .failure(let error):
                self?.errorMessage.accept("Job çekilemedi: \(error.localizedDescription)")
            }
        }
    }
}
