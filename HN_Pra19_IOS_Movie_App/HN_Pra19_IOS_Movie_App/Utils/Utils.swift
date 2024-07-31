//
//  Utils.swift
//  TUANNM_MOVIE_06
//
//  Created by Khanh Vu on 23/03/2024.
//

import Foundation

class Utils {
    static func showLoading() {
        ActivityIndicatorUtility.show()
    }
    
    static func hideLoading() {
        ActivityIndicatorUtility.hide()
    }
    
    static func clearCache() {
        ImageCacheManager.shared.clearAllCache()
    }
}
