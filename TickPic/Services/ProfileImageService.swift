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
    private var currentTask: URLSessionDataTask?

    private(set) var avatarURL: String?

    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        semaphore.wait()
        defer { semaphore.signal() }

        currentTask?.cancel()

        let tokenStorage = OAuth2TokenStorage()
        guard let token = tokenStorage.token else {
            completion(.failure(NSError(domain: "No token found", code: 0, userInfo: nil)))
            return
        }

        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }

            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                let profileImageURL = userResult.profileImage.small
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            } catch {
                completion(.failure(error))
            }
        }
        currentTask?.resume()
    }
}


