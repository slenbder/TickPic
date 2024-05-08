//
//  OAuthTokenResponseBody.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//

import Foundation
import WebKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
