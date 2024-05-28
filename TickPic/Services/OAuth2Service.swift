//
//  OAuth2Service.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//  Test Mark

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    let tokenStorage = OAuth2TokenStorage()
    
    private init() {}
    
    private(set) var authToken: String? {
        get { tokenStorage.token }
        set { tokenStorage.token = newValue }
    }
    
    private var currentTask: URLSessionTask?
    private var currentCode: String?

    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let currentCode = self.currentCode, currentCode == code {
            self.currentTask?.cancel()
        } else if self.currentTask != nil {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        guard let request = self.makeTokenRequest(with: code) else {
            print("Error: Failed to create token request.")
            let error = NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create token request."])
            completion(.failure(NetworkError.urlRequestError(error)))
            return
        }
        
        self.currentCode = code
        self.currentTask = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            self.currentTask = nil
            self.currentCode = nil
            
            switch result {
            case .success(let tokenResponse):
                let accessToken = tokenResponse.accessToken
                self.tokenStorage.token = accessToken
                DispatchQueue.main.async {
                    completion(.success(accessToken))
                }
            case .failure(let error):
                print("Network request error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.currentTask?.resume()
    }
    
    private func makeTokenRequest(with code: String) -> URLRequest? {
        guard let url = URL(string: Constants.unsplashTokenURLString) else {
            print("Error: Failed to create URL for token request")
            return nil
        }
        
        let accessKey = Constants.accessKey
        let secretKey = Constants.secretKey
        let redirectURI = Constants.redirectURI
        
        let params: [String: Any] = [
            "client_id": accessKey,
            "client_secret": secretKey,
            "redirect_uri": redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            return urlRequest
        } catch {
            print("Error creating token request: \(error)")
            return nil
        }
    }
}

