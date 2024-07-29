//
//  Enviroment.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 29/7/24.
//

import Foundation

public enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    private static let inforDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let key = Environment.inforDictionary[Keys.apiKey] as? String else {
            fatalError("CORE_BASE_URL not set in plist")
        }
        return key
    }()
}
