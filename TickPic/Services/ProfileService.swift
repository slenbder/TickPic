//
//  ProfileService.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 18.05.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    
    private let semaphore = DispatchSemaphore(value: 1)
    private(set) var currentProfile: Profile?
    private(set) var profile: Profile?
    
    struct ProfileResult: Codable {
        
        let username: String
        let firstName: String
        let lastName: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
        init(username: String, firstName: String, lastName: String?, bio: String?) {
            self.username = username
            self.name = "\(firstName) \(lastName ?? "")"
            self.loginName = "@\(username)"
            self.bio = bio ?? ""
        }
    }
    
    func makeRequest(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        semaphore.wait()
        defer { semaphore.signal() }
        
        let url = URL(string: "https://api.unsplash.com/me")!
        let request = makeRequest(url: url, bearerToken: token)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.unsplash", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(username: profileResult.username, firstName: profileResult.firstName, lastName: profileResult.lastName, bio: profileResult.bio)
                self.currentProfile = profile
                self.profile = profile
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}