//
//  LoginModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 20.04.2025.
//


struct LoginRequest: Encodable {
    let username: String
    let password: String
}

struct LoginResponse: Decodable {
    let message: String
    let token: String?
    let refresh_token: String?
    let user_id: String
    let error: String?
}

// Yeni token cevabı modeli
struct TokenResponse: Decodable {
    let token: String
}

