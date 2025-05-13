//
//  RegisterModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 20.04.2025.
//

struct RegisterRequest: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
    }
}

struct RegisterResponse: Decodable {
    let message: String
    let error: String?
}

