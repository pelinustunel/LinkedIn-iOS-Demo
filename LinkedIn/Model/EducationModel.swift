//
//  EducationModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 24.04.2025.
//

struct EducationModel: Decodable {
    let id: Int?
    let school: String
    let degree: String
    let education_image: String?
    let field_of_study: String
    let education_year: String
}
