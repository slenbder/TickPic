import Foundation

enum Constants {
    // MARK: - API Keys
    
    static let accessKey = "QvyZhO6TX0a3DXLiN82ecHIR6SAsCb3EkdBzna6efGM"
    static let secretKey = "RtcVfP5lt6DNpTlSsFBglUeXNxIAGIwMhx34NVxPCVs"
    
    // MARK: - OAuth Configuration
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let baseURL = URL(string: "https://unsplash.com")!
  }

  enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
  }
  struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
      self.accessKey = accessKey
      self.secretKey = secretKey
      self.redirectURI = redirectURI
      self.accessScope = accessScope
      self.defaultBaseURL = defaultBaseURL
      self.authURLString = authURLString
    }
    static var standard: AuthConfiguration {
      return AuthConfiguration(accessKey: Constants.accessKey,
                               secretKey: Constants.secretKey,
                               redirectURI: Constants.redirectURI,
                               accessScope: Constants.accessScope,
                               authURLString: WebViewConstants.unsplashAuthorizeURLString,
                               defaultBaseURL: Constants.defaultBaseURL)
    }
  }
