//
//  MessageViewModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 26.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

class MessageViewModel {
    
    // Output: Conversation listesi
    let conversations = BehaviorRelay<[ConversationModel]>(value: [])
    let errorMessage = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()

    // Kullanıcı ID ve Token (dışarıdan alınabilir)
    var token: String?
    var currentUserId: String?

    // MARK: - Message Fetching
    func fetchConversations() {
        guard let token = token, let currentUserId = currentUserId else {
            errorMessage.accept("Token veya kullanıcı ID bulunamadı.")
            return
        }

        MessageManager.shared.fetchMessages(token: token, userId: currentUserId) { [weak self] result in
            switch result {
            case .success(let conversationList):// ✅ Backend zaten doğru veriyi döndürüyor!
            case .failure(let error):
                self?.errorMessage.accept("Mesajlar çekilemedi: \(error.localizedDescription)")
            }
        }

    }
}
