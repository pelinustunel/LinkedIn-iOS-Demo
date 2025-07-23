//
//  MessageViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 11.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire


class MessageViewController : UIViewController {
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let conversations = BehaviorRelay<[ConversationModel]>(value: [])
    
    private var token: String?
    private var currentUserId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadUserInfo()
        fetchConversations()
        bindTableView()
        
    }
    
    
    private func setupTableView() {
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        messageTableView.register(nib, forCellReuseIdentifier: "MessageTableViewCell")
    }
    
    private func loadUserInfo() {
        token = UserDefaults.standard.string(forKey: "userToken")
        currentUserId = UserDefaults.standard.string(forKey: "userId")
        
        guard token != nil, currentUserId != nil else {
            print("Token veya kullanıcı ID'si bulunamadı")
            return
        }
    }
    
    private func fetchConversations() {
        guard let token = token, let userId = currentUserId else { return }
        
        MessageManager.shared.fetchMessages(token: token, userId: userId) { [weak self] result in
            switch result {
            case .success(let conversationList):
                self?.conversations.accept(conversationList)
            case .failure(let error):
                print("Mesajlar çekilemedi: \(error.localizedDescription)")
            }
        }
    }
    
    private func bindTableView() {
        conversations
            .bind(to: messageTableView.rx.items(cellIdentifier: "MessageTableViewCell", cellType: MessageTableViewCell.self)) { index, conversation, cell in
                
                cell.messagePersonNameLabel.text = conversation.other_user_name
                cell.messageLabel.text = conversation.last_message
                
                if let url = URL(string: conversation.other_user_image) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.messageProfileImageView.image = image
                            }
                        }
                    }.resume()
                } else {
                    cell.messageProfileImageView.image = UIImage(named: "profile")
                }
            }
            .disposed(by: disposeBag)
        

        messageTableView.rx.modelSelected(ConversationModel.self)
            .subscribe(onNext: { [weak self] selectedConversation in
                guard let self = self else { return }
                let messageDetailVC = MessageDetailViewController(nibName: "MessageDetailView", bundle: nil)
                
                messageDetailVC.otherUserId = selectedConversation.other_user_id
                if let sheet = messageDetailVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 20
                }
                self.present(messageDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
