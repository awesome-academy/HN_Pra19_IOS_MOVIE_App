//
//  VideoTrailerModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import Foundation

struct VideosTrailerModel: Codable {
    let id: Int
    let results: [VideoModel]
}
