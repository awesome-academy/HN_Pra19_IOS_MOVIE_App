//
//  SearchModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

class SearchModel: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genre_ids: [Int]?
    let id: Int
    let title: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    var mediaType: MediaType?
    let popularity: Double?
    let releaseDate: String?
    let name, originalName, firstAirDate: String?
    let originCountry: [String]?
    let gender: Int?
    let knownForDepartment: String?
    let profilePath: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Double?

    enum CodingKeys: String, CodingKey {
        case adult
        case genre_ids
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case popularity
        case releaseDate = "release_date"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case video
        case vote_average
        case vote_count
    }
    
    var posterURL: String {
        return APIService.baseImage + (posterPath ?? "")
    }
    
    var profileURL: String {
        return APIService.baseImage + (profilePath ?? "")
    }
    
    var backdropURL: String {
        return APIService.baseImage + (backdropPath ?? "")
    }
    
    func getReleaseDate() -> String {
        if let releaseDate = releaseDate {
            return releaseDate
        }
        if let firstAirDate = firstAirDate {
            return firstAirDate
        }
        return ""
    }
    
    func getNation() -> String {
        if let countryCode = originCountry?.first {
            return Locale.current.localizedString(forRegionCode: countryCode) ?? ""
        }
        if let language = originalLanguage {
            return Locale.current.localizedString(forLanguageCode: language) ?? ""
        }
        
        return ""
    }
    
    func getName() -> String {
        return (mediaType == .movie ? title : name) ?? ""
    }
    
    func getTitle() -> String {
        if let title = title {
            return title
        }
        return name ?? ""
    }
    
    func getType() -> MediaType {
        return mediaType ?? .movie
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    case person = "person"
    
    var title: String {
        switch self {
        case .movie:
            return "Movie"
        case .tv:
            return "TV Show"
        case .person:
            return " Actor"
        }
    }
}
