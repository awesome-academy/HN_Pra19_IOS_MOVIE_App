//
//  MoviesResult.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

struct MoviesResult: Codable {
    let page: Int
    let results: [MoviesModel]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
