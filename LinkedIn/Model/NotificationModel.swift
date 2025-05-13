//
//  NotificationModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 21.04.2025.
//

struct NotificationModel: Decodable {
    let notification_id: Int
    let notification_image: String?
    let message: String
    let timestamp: String?
}
