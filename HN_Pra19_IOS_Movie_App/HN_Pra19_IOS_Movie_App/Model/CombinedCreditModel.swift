//
//  CombinedCreditModel.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

struct CombinedCreditModel: Codable {
    let cast: [SearchModel]
    let crew: [SearchModel]
    let id: Int
}
