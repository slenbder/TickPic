//
//  OAuth2TokenStorage.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//

import Foundation
import WebKit

class OAuth2TokenStorage {
    private let tokenKey = "OAuth2AccessToken"
    
    var token: String? {
        get {return UserDefaults.standard.string(forKey: tokenKey)}
        set {UserDefaults.standard.set(newValue, forKey: tokenKey)}
    }
}
