import Foundation

final class ProfileImageService {
  static let shared = ProfileImageService()
  static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
  private (set) var avatarURL: String?
  private var task: URLSessionTask?
  private let urlSession = URLSession.shared
  private let token = OAuth2TokenStorage()
  private let decoder: JSONDecoder = JSONDecoder()
  private init () {}

  private func makeProfileInfoRequest(token: String, username: String) -> URLRequest? {
    let baseURL = Constants.defaultBaseURL

    var imageURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    imageURL?.path = "/users/\(username)"

    guard let url = imageURL?.url else {
      assertionFailure("Failed to create URL")
      return nil
    }
    var request = URLRequest(url: url)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }


  func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
    assert(Thread.isMainThread)
    task?.cancel()

    guard let request = makeProfileInfoRequest(token: token.token!, username: username) else {
      completion(.failure(AuthServiceError.invalidRequest))
      return
    }

    let task = urlSession.objectTask(for: request){ [weak self] (result: Result<ProfileResult, Error>)  in
      guard let self else { return }
      switch result {
      case .success(let profileResponseImage):
        let avatarURL = profileResponseImage.profileImage.large
        self.avatarURL = avatarURL
        completion(.success(avatarURL))
        print("Successfully parsed: \(avatarURL)")
        NotificationCenter.default.post(
          name: ProfileImageService.didChangeNotification,
          object: self,
          userInfo: ["URL": avatarURL])

      case .failure(let error):
        print("[ProfileImageService]: AuthServiceError - \(error)")
        completion(.failure(error))
      }
      self.task = nil
    }
    self.task = task
    task.resume()
  }
}
extension ProfileImageService {
  func clearProfileImage() {
  }
}
