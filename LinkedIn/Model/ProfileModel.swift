//
//  ProfileModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 26.04.2025.
//

struct ProfileModel: Decodable {
    let user_id: Int
    let name: String
    let profile_picture: String
    let title: String
    let location: String
    let education: String
    let connection: String
}
