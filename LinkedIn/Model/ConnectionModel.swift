//
//  ConnectionModel.swift
//  LinkedIn
//
//  Created by Pelin Üstünel on 23.04.2025.
//

struct ConnectionModel: Decodable {
    let id: Int
    let name: String?
    let job: String?
    let mutual_connection: String?
    let date: String?
    let profile_image: String?
    let isApproved: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case date
        case mutual_connection
        case profile_image
        case isApproved
    }
}
