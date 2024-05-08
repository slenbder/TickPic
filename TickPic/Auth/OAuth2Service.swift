//
//  OAuth2Service.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    let tokenStorage = OAuth2TokenStorage()
    
    private init() {}
    
    private (set) var authToken: String? {
        get { tokenStorage.token }
        set { tokenStorage.token = newValue }
    }
    
    private func makeOAuthTokenRequest(with code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
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
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(with: code) else {
            let error = NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create token request."])
            completion(.failure(NetworkError.urlRequestError(error)))
            return
        }
        
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = tokenResponse.accessToken
                    
                    // Сохраняем токен в хранилище
                    self.tokenStorage.token = accessToken
                    
                    // Уведомляем об успешной авторизации с передачей токена
                    DispatchQueue.main.async {
                        completion(.success(accessToken))
                    }
                } catch {
                    // Если не удалось декодировать ответ, возвращаем ошибку
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                // Если произошла ошибка при получении данных, возвращаем ошибку
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}
