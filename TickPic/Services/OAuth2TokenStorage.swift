import SwiftKeychainWrapper

// MARK: - OAuth2TokenStorage

class OAuth2TokenStorage {
    
    // MARK: - Properties
    
    private let tokenKey = "OAuth2AccessToken"
    
    // MARK: - Public API
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
