//
//  ProfileImageService.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 22.05.2024.
//

import Foundation

final class ProfileImageService {
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    private let semaphore = DispatchSemaphore(value: 1)
    private var currentTask: URLSessionTask?
    
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        semaphore.wait()
        defer { semaphore.signal() }
        
        currentTask?.cancel()
        
        let tokenStorage = OAuth2TokenStorage()
        guard let token = tokenStorage.token else {
            let error = NSError(domain: "ProfileImageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No token found"])
            print("[fetchProfileImageURL]: NetworkError - \(error.localizedDescription), Username: \(username)")
            completion(.failure(error))
            return
        }
        
        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "ProfileImageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            print("[fetchProfileImageURL]: NetworkError - \(error.localizedDescription), URL: \(urlString)")
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        currentTask = URLSession.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let profileImageURL = userResult.profileImage.small
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            case .failure(let error):
                print("[fetchProfileImageURL]: NetworkError - \(error.localizedDescription), Username: \(username)")
                completion(.failure(error))
            }
        }
        currentTask?.resume()
    }
}


