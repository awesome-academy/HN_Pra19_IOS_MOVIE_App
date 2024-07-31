//
//  ImageCacheManager.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 30/7/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0]
    }()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let diskImage = UIImage(contentsOfFile: fileURL.path) {
            cache.setObject(diskImage, forKey: cacheKey)
            completion(diskImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            try? data.write(to: fileURL)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
    func clearMemoryCache() {
        cache.removeAllObjects()
    }
    
    func clearDiskCache() {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory,
                                                               includingPropertiesForKeys: nil,
                                                               options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error clearing disk cache: \(error.localizedDescription)")
        }
    }
    
    func clearAllCache() {
        clearMemoryCache()
        clearDiskCache()
    }
}
