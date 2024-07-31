//
//  ActivityIndicatorUtility.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 30/7/24.
//

import Foundation
import UIKit

final class ActivityIndicatorUtility {
    static var activityIndicator: UIActivityIndicatorView?
    
    static func show() {
        DispatchQueue.main.async {
            if activityIndicator == nil {
                if #available(iOS 13.0, *) {
                    activityIndicator = UIActivityIndicatorView(style: .large)
                } else {
                    activityIndicator = UIActivityIndicatorView()
                    activityIndicator?.style = .gray
                }
                activityIndicator?.color = .gray
                activityIndicator?.center = UIApplication.shared.keyWindow?.center ?? CGPoint.zero
                activityIndicator?.hidesWhenStopped = true
            }
            UIApplication.shared.keyWindow?.addSubview(activityIndicator!)
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
            activityIndicator?.backgroundColor = .white
            activityIndicator?.setShadow(offset: CGSize(width: 1, height: 1), radius: 5, color: .black, opacity: 0.3)
            activityIndicator?.layer.cornerRadius = 5
            activityIndicator?.frame.size = CGSize(width: 50, height: 50)
            activityIndicator?.startAnimating()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
}
