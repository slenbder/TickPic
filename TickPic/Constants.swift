//
//  Constants.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 04.05.2024.
//

import Foundation
enum Constants {
    static let accessKey = "QvyZhO6TX0a3DXLiN82ecHIR6SAsCb3EkdBzna6efGM"
    static let secretKey = "RtcVfP5lt6DNpTlSsFBglUeXNxIAGIwMhx34NVxPCVs"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}
