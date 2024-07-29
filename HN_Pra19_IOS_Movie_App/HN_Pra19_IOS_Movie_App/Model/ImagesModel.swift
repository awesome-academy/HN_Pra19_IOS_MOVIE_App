//
//  ImagesModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khanh Vu on 01/12/2023.
//

import Foundation

struct ImagesModel: Codable {
    let backdrops: [BackdropModel]
    let id: Int
    let logos, posters: [BackdropModel]
}
