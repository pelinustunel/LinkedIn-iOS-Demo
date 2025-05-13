//
//  JobModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 21.04.2025.
//

struct JobModel: Decodable {
    let job_id: Int
    let title: String?
    let company: String?
    let company_logo: String?
    let location: String?
    let skill: String?
    let description: String?
    let date_posted: String?

    enum CodingKeys: String, CodingKey {
        case job_id
        case title
        case company
        case company_logo
        case location
        case skill
        case description
        case date_posted
    }
}



