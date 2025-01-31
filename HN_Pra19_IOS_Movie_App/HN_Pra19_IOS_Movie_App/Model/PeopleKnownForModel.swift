//
//  PeopleKnownForModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

struct PeopleKnownForModel: Codable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let name: String?
    let originalLanguage: String
    let originalName: String?
    let overview, posterPath: String?
    let mediaType: MediaType
    let genreIDS: [Int]
    let popularity: Double
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]?
    let title, originalTitle, releaseDate: String?
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case video
    }
    
    var posterURL: String {
        return APIService.baseImage + (posterPath ?? "")
    }
}

