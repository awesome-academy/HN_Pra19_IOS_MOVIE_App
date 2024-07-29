//
//  CreditModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khanh Vu on 01/12/2023.
//

import Foundation

struct CreditsModel: Codable {
    let id: Int
    let cast, crew: [CastModel]
}
