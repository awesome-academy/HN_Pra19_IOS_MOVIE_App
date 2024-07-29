//
//  ActorModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

struct ActorModel: Codable {
    let adult: Bool
    let alsoKnow: [String]?
    let gender, id: Int?
    let birthday: String?
    let deathday: String?
    let biography: String?
    let knownForDepartment: String?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let knownFor: [PeopleKnownForModel] = []
    let place_of_birth: String?
    let homepage: String?
    let imdb_id: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case biography
        case birthday
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case knownFor = "known_for"
        case alsoKnow = "also_known_as"
        case deathday
        case place_of_birth
        case homepage
        case imdb_id
    }
    
    var profileURL: String {
        return APIService.baseImage + (profilePath ?? "")
    }
}
