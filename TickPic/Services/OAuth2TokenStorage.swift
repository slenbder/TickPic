import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "OAuth2Token")
        }
        set {
          guard let newValue = newValue else { return }
          KeychainWrapper.standard.set(newValue, forKey: "OAuth2Token")
        }
    }
  func clearToken() {
      KeychainWrapper.standard.removeObject(forKey: "OAuth2Token")
  }
}
