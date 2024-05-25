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
    
    private(set) var currentProfile: Profile?
    private(set) var profile: Profile?
    
    func makeRequest(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let url = URL(string: Constants.meEndpoint)!
        let request = makeRequest(url: url, bearerToken: token)
        
        URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username, firstName: profileResult.firstName, lastName: profileResult.lastName, bio: profileResult.bio)
                self.currentProfile = profile
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
}
