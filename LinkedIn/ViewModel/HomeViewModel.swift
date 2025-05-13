//
//  HomeViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 25.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    let posts = BehaviorRelay<[PostModel]>(value: [])
    let errorMessage = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    func fetchPosts() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            errorMessage.accept("Token bulunamadı")
            return
        }
        
        PostManager.shared.fetchPosts(token: token) { [weak self] result in
            switch result {
            case .success(let postList):
                self?.posts.accept(postList)
            case .failure(let error):
                self?.errorMessage.accept("Post çekilemedi: \(error.localizedDescription)")
            }
        }
    }
}
