//
//  GlobalFuntions.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit

func mainAsynAfter(_ time: Double,_ completion:@escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        completion()
    }
}

func mainAsync(_ completion:@escaping (() -> Void)) {
    DispatchQueue.main.async {
        completion()
    }
}

func getWindow() -> UIWindow? {
    let sceneDelegate = UIApplication.shared.connectedScenes
        .first?.delegate as? SceneDelegate
    return sceneDelegate?.window
}

func getWindowSize() -> CGSize {
    guard let window = getWindow() else {
        return .zero
    }
    return window.frame.size
}

func getDeviceUUID() -> UUID? {
    if let uuid = UIDevice.current.identifierForVendor {
        // The identifierForVendor property returns a UUID for the current device
        return uuid
    }
    return nil
}

func openAppPageInAppStore(appID: String, forReview: Bool) {
    var urlStr = "https://itunes.apple.com/app/id\(appID)"
    
    if forReview == true {
        urlStr += "?action=write-review"
    }
    
    guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}

func getIOSVersion() -> String {
    return UIDevice.current.systemVersion
}

func getDeviceModelName() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    
    return machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
}

func getAppVersion() -> String? {
    if let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String {
        return version
    }
    return nil
}

func isLightColor(brightness: CGFloat, saturation: CGFloat) -> Bool {
    return 1 - brightness < 0.4 && saturation < 0.5
}

func isIphone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}


public extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    // Append a element that is not in array:
    mutating func appendUnduplicate(object: Element) {
        if !contains(object) {
            append(object)
        }
    }
    
    func indexOf(object: Element) -> Int? {
        return (self as NSArray).contains(object) ? (self as NSArray).index(of: object) : nil
    }
    
    subscript(index index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

public extension Array where Element: Comparable {
    func containsElements(as other: [Element]) -> Bool {
        for element in other {
            if !self.contains(element) { return false }
        }
        return true
    }
}

extension Int {
    func secondsToHoursMinutesSeconds(_ forceWithHour: Bool = false) -> String {
        if forceWithHour {
            return String(format: "%02d:%02d:%02d", self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        } else {
            return self > 3600
            ? String(format: "%02d:%02d:%02d", self / 3600, (self % 3600) / 60, (self % 3600) % 60)
            : String(format: "%02d:%02d", (self % 3600) / 60, (self % 3600) % 60)
        }
    }
    
    func toDurationMovies() -> String {
        return String(format: "%02dh %02dm", (self % 3600) / 60, (self % 3600) % 60)
    }
}

extension CGFloat {
    func toRadiant() -> CGFloat {
        return self * .pi / 180
    }
}
