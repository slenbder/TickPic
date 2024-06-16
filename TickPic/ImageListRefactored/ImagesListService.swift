import Foundation

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}

extension ImagesListService: ImagesListServiceProtocol { }

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
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Failed to fetch photos: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                self?.photos.append(contentsOf: photoResults.map { PhotoMapper.map(from: $0) })
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            } catch {
                print("Failed to decode photos: \(error)")
            }
        }
        
        task.resume()
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard data != nil else {
                completion(.failure(NetworkError.urlRequestError(NSError(domain: "No data received", code: 0, userInfo: nil))))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    
    func clearPhotos() {
        photos.removeAll()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }
}
