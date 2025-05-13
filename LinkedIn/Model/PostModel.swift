//
//  PostModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 21.04.2025.
//

struct PostModel: Decodable {
    let post_id: Int
    let user_id: String
    let content: String
    let job_text : String?
    let image_url: String?
    let profile_image_url: String?
    let timestamp: String
    let likes: Int
    let comments: [String]
}
