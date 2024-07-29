//
//  ActorResultModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khanh Vu on 03/12/2023.
//

import Foundation

struct ActorResultModel: Codable {
    let page: Int
    let results: [ActorModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
