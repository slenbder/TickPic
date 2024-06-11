import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    internal var photos: [Photo] = []
    private let tokenStorage = OAuth2TokenStorage()
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        guard let token = tokenStorage.token else {
            print("No token found")
            return
        }
        
        var request = URLRequest(url: URL(string: "\(Constants.defaultBaseURL)/photos")!)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                    self?.photos.append(contentsOf: photoResults.map { PhotoMapper.map(from: $0) })
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                } catch {
                    print("Failed to decode photos: \(error)")
                }
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            completion(.failure(NetworkError.urlRequestError(NSError(domain: "No token found", code: 0, userInfo: nil))))
            return
        }
        
        let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func clearPhotos() {
        photos.removeAll()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }
}
