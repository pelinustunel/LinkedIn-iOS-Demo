//
//  MessageDetailViewController.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 17.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

struct ChatMessage {
    let text: String
    let isSentByCurrentUser: Bool
}


class MessageDetailViewController : UIViewController, UITextViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var messageDetailTableView: UITableView!
    @IBOutlet weak var textMessage: UITextView!
    
    var otherUserId: String?  
    private var messages: [ChatMessage] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTextMessageView()
        fetchChatHistory()
    }
    
    private func setupTableView() {
        messageDetailTableView.accessibilityIdentifier = "MessageDetailTable"
        messageDetailTableView.separatorStyle = .none
        messageDetailTableView.allowsSelection = false
        
        messageDetailTableView.register(UINib(nibName: "SenderTableCellView", bundle: nil), forCellReuseIdentifier: "SenderTableCellView")
        messageDetailTableView.register(UINib(nibName: "ReceiverTableCellView", bundle: nil), forCellReuseIdentifier: "ReceiverTableCellView")
        
        messageDetailTableView.dataSource = self
    }
    
    private func setupTextMessageView() {
        textMessage.delegate = self
        textMessage.text = "Write a message..."
        textMessage.textColor = .lightGray
        textMessage.isEditable = true
        textMessage.isSelectable = true
        textMessage.isUserInteractionEnabled = true
        textMessage.isScrollEnabled = true
    }
    
    private func fetchChatHistory() {
        guard let token = UserDefaults.standard.string(forKey: "userToken"),
              let currentUserId = UserDefaults.standard.string(forKey: "userId"),
              let otherUserId = otherUserId else {
            print("Token, kullanıcı ID'si veya diğer kullanıcı ID'si bulunamadı")
            return
        }
        
        // ✅ Artık messageId değil, currentUserId ve otherUserId kullanıyoruz!
        MessageManager.shared.fetchChatHistory(token: token, currentUserId: currentUserId, otherUserId: otherUserId) { [weak self] result in
            switch result {
            case .success(let messageList):
                self?.messages = messageList.map { message in
                    let isCurrentUserSender = (message.sender_id == currentUserId)
                    return ChatMessage(text: message.content, isSentByCurrentUser: isCurrentUserSender)
                }
                DispatchQueue.main.async {
                    self?.messageDetailTableView.reloadData()
                }
            case .failure(let error):
                print("Mesaj geçmişi çekilemedi: \(error)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.isSentByCurrentUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableCellView", for: indexPath) as! ReceiverTableCellViewController
            cell.receiverMessageLabel.text = message.text
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableCellView", for: indexPath) as! SenderTableCellViewController
            cell.senderMessageLabel.text = message.text
            return cell
        }
    }
    
    // MARK: - UITextViewDelegate (placeholder behavior)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a message..." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Write a message..."
            textView.textColor = .lightGray
        }
    }
    
}
