//
//  ToastEnum.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 30/7/24.
//

import Foundation
import UIKit

enum ToastEnum {
    case success
    case failed
    case warning
    
    var color: UIColor? {
        switch self {
        case .failed:
            return UIColor(hex: "#FF334B")
        case .success:
            return UIColor(hex: "#02CB8F")
        case .warning:
            return UIColor(hex: "#E9B633")
        }
    }
}
