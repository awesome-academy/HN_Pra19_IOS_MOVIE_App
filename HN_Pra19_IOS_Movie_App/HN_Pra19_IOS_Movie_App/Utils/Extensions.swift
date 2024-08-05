//
//  Extensions.swift
//  TUANNM_MOVIE_21
//
//  Created by Khánh Vũ on 1/6/24.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000" // Return black color if unable to get color components
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        return hexString
    }
}


extension String {
    //MARK: - Trimming
    enum TrimmingOptions {
        case all
        case leading
        case trailing
        case leadingAndTrailing
    }
    
    func trimming(spaces: TrimmingOptions, using characterSet: CharacterSet = .whitespacesAndNewlines) ->  String {
        switch spaces {
        case .all: return trimmingAllSpaces(using: characterSet)
        case .leading: return trimingLeadingSpaces(using: characterSet)
        case .trailing: return trimingTrailingSpaces(using: characterSet)
        case .leadingAndTrailing:  return trimmingLeadingAndTrailingSpaces(using: characterSet)
        }
    }
    
    private func trimmingAllSpaces(using characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
    
    private func trimingLeadingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }
        
        return String(self[index...])
    }
    
    private func trimingTrailingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }
        
        return String(self[...index])
    }
    
    private func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
    func trimSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIApplication {
    
    var safeInset: UIEdgeInsets? {
        return firstKeyWindow?.safeAreaInsets
    }
    
    var firstKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .first?.windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.firstKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

//MARK: - Add Gesture
extension UIView {
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = ((UITapGestureRecognizer) -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: ((UITapGestureRecognizer) -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?(sender)
        } else {
            print("no action")
        }
    }
}

extension UIImageView {
    func setImage(_ urlStr: String, _ placeholder: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            return
        }
        ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
            guard let self, let img = image else {
                self?.image = placeholder
                completion?(placeholder)
                return
            }
            self.image = img
            completion?(img)
        }
    }
    
    func setImage(_ url: URL, _ placeholder: UIImage?, completion: ((UIImage?) -> Void)? = nil) {
        ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
            guard let self, let img = image else {
                self?.image = placeholder
                completion?(placeholder)
                return
            }
            self.image = img
            completion?(img)
        }
    }
    
    func applyShadowAndCornerRadius(cornerRadius: CGFloat,
                                    shadowColor: UIColor = .black,
                                    shadowOpacity: Float = 0.5,
                                    shadowOffset: CGSize = CGSize(width: 0, height: 2),
                                    shadowRadius: CGFloat = 4) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
}

extension UITableView {
    var triggerOffset: CGFloat {
        return 80.0
    }
    
    var canShowLoadmore: Bool {
        let contentOffset = contentOffset
        let visibleHeight = frame.height - contentInset.top - contentInset.bottom
        let yOffset = contentOffset.y + contentInset.top + contentInset.bottom + visibleHeight
        let contentHeight = contentSize.height - triggerOffset
        if yOffset >= contentHeight,
           contentHeight >= bounds.height {
            return true
        }
        
        return false
        
    }
    
    func showLoadMore() {
        let activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 50)
        
        tableFooterView = activityIndicator
        activityIndicator.startAnimating()
    }
    
    func hideLoadMore() {
        tableFooterView = nil
    }
}

extension UICollectionView {
    //Loadmore
    var triggerOffset: CGFloat {
        return 80.0
    }
    
    var canShowLoadmore: Bool {
        let contentOffset = contentOffset
        let visibleHeight = frame.height - contentInset.top - contentInset.bottom
        let yOffset = contentOffset.y + contentInset.top + visibleHeight
        let contentHeight = contentSize.height - triggerOffset
        if yOffset >= contentHeight,
           contentHeight >= bounds.height {
            return true
        }
        return false
    }
}
