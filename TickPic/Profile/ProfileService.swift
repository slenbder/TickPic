import Foundation

final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let decoder: JSONDecoder = JSONDecoder()
    private(set) var profile: Profile?
    private var lastToken: String?
    
    private init () {}
    
    static let shared = ProfileService()
    
    private func makeInfoRequest(token: String) -> URLRequest? {
        let baseURL = Constants.defaultBaseURL
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = "/me"
        
        guard let url = components?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        lastToken = token
        
        guard let request = makeInfoRequest(token: token) else {
            print("ProfileService: makeInfoRequest - \(AuthServiceError.invalidRequest)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request){ [weak self] (result: Result<ProfileResult, Error>)  in
            guard let self else { return }
            switch result {
            case .success(let profileResponse):
                let profile = Profile(editorProfile: profileResponse)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("ProfileService: NetworkError - \(error)")
                completion(.failure(error))
            }
            self.lastToken = nil
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
extension ProfileService {
    func clearProfileData() {
        self.profile = nil
    }
}
