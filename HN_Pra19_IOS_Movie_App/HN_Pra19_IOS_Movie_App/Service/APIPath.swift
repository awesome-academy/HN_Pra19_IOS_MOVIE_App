//
//  APIPath.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

enum APIPath {
    case popularMovie
    case popularTV
    case search
    case creditMovie(id: Int)
    case creditTV(id: Int)
    case imagesMovie(id: Int)
    case imagesTV(id: Int)
    case peopleDetail(id: Int)
    case peoplePopular
    case videosMovie(id: Int)
    case videosTV(id: Int)
    case combinedCredit(id: Int)

    var path: String {
        switch self {
        case .popularMovie:
            return "/movie/popular"
        case .popularTV:
            return "/tv/popular"
        case .search:
            return "/search/multi"
        case .creditMovie(let id):
            return "/movie/\(id)/credits"
        case .creditTV(let id):
            return "/tv/\(id)/credits"
        case .imagesMovie(id: let id):
            return "/movie/\(id)/images"
        case .imagesTV(id: let id):
            return "/tv/\(id)/images"
        case .peopleDetail(let id):
            return "/person/\(id)"
        case .peoplePopular:
            return "/person/popular"
        case .combinedCredit(let id):
            return "/person/\(id)/combined_credits"
        case .videosMovie(let id):
            return "/movie/\(id)/videos"
        case .videosTV(let id):
            return "/tv/\(id)/videos"
        }
    }
    
    func getURL() -> String {
        return APIService.baseURL + path
    }
}
