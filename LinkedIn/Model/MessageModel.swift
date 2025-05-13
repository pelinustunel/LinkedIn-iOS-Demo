//
//  MessageModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 23.04.2025.
//

// Tekil mesajlar için (message/detail, send_message)
struct MessageModel: Decodable {
    let message_id: Int
    let sender_id: String
    let sender_image: String?
    let sender_name: String
    let receiver_id: String
    let receiver_image: String?
    let receiver_name: String
    let content: String
    let image_url: String?
    let timestamp: String
}

// Conversation listesi için (message/list)
struct ConversationModel: Decodable {
    let other_user_id: String
    let other_user_name: String
    let other_user_image: String
    let last_message: String
    let last_message_time: String
}

