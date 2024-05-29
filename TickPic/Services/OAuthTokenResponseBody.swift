import Foundation
import WebKit

// MARK: - OAuthTokenResponseBody

struct OAuthTokenResponseBody: Decodable {
    
    // MARK: - Properties
    
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
