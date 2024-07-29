//
//  MoviesModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khanh Vu on 29/11/2023.
//

import Foundation

struct MoviesModel: Codable {
    var adult: Bool
    var backdropPath: String?
    var genreID: [Int]
    var id: Int
    var originalLanguge: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Float
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreID = "genre_ids"
        case id
        case originalLanguge = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
    
    var posterURL: String {
        return APIService.baseImage + (posterPath ?? "")
    }
    
    var backDropURL: String {
        return APIService.baseImage + (backdropPath ?? "")
    }
}
