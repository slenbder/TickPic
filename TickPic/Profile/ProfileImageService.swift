import Foundation

// MARK: - ProfileImageService

final class ProfileImageService {
    
    // MARK: - Constants
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Properties
    
    private var currentTask: URLSessionTask?
    private(set) var avatarURL: String?
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        currentTask?.cancel()
        
        let tokenStorage = OAuth2TokenStorage()
        guard let token = tokenStorage.token else {
            let error = NSError(domain: "No token found", code: 0, userInfo: nil)
            completion(.failure(error))
            print("Error: \(error.localizedDescription)")
            return
        }
        
        let urlString = "\(Constants.defaultBaseURL)/users/\(username)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            print("Error: \(error.localizedDescription)")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        currentTask = URLSession.shared.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let profileImageURL = userResult.profileImage.large
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            case .failure(let error):
                completion(.failure(error))
                print("Error fetching profile image URL: \(error.localizedDescription)")
            }
        }
        currentTask?.resume()
    }
    
    func clearAvatarURL() {
        avatarURL = nil
    }
}
