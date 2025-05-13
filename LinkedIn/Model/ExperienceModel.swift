//
//  ExperienceModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

struct ExperienceModel : Decodable {
    let id: Int?
    let company_logo: String?
    let company_name: String
    let position: String
    let experience_year: String
    let work_mode: String
}
