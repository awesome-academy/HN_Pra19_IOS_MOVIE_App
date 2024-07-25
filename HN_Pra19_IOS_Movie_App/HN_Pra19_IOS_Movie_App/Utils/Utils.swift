//
//  Utils.swift
//  TUANNM_MOVIE_06
//
//  Created by Khanh Vu on 23/03/2024.
//

import Foundation
import ProgressHUD
import SDWebImage

class Utils {
    static func showLoading(_ text: String? = nil,_ interaction: Bool = false) {
        ProgressHUD.animate(text, interaction: interaction)
    }
    
    static func hideLoading() {
        ProgressHUD.dismiss()
    }
    
    static func clearCache() {
        SDImageCache.shared.clearMemory()
    }
}
