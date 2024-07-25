//
//  Constant.swift
//  TUANNM_MOVIE_17
//
//  Created by Khánh Vũ on 16/5/24.
//

import Foundation
import UIKit

struct MainColor {
    static var colorPrimary: UIColor? {
        return UIColor(hex: "#F0EAB1")
    }
    
    static var colorTopBgr: UIColor? {
        return UIColor(hex: "#F59C14")
    }
    
    static var colorTextYellow: UIColor {
        return UIColor(hex: "#F4B343") ?? .yellow
    }
    
    static var colorTextWhite: UIColor? {
        return .white
    }
}

struct MainIcon {
    static var icnTabbar: UIImage? {
        return UIImage(named: "icn_tabbar")
    }
    
    static var icnDownload: UIImage? {
        return UIImage(named: "icn_download")
    }
    
    static var icnSearch: UIImage? {
        return UIImage(named: "icn_search")
    }
    
    static var icnResource: UIImage? {
        return UIImage(named: "icn_resource")
    }
    
    static var icnSearchSmall: UIImage? {
        return UIImage(named: "icn_search_small")
    }
    
}
