import Foundation

// MARK: - ProfileService

final class ProfileService {
    
    // MARK: - Constants
    
    static let shared = ProfileService()
    
    // MARK: - Properties
    
    private(set) var currentProfile: Profile?
    private(set) var profile: Profile?
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Public Methods
    
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
                print("Error fetching profile: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func clearProfile() {
        currentProfile = nil
        profile = nil
    }
    
    // MARK: - Private Methods
    
    private func makeRequest(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
