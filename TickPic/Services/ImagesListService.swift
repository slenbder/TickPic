import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private var lastLoadedPage = 0
    private var isFetching = false
    private(set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        isFetching = true
        lastLoadedPage += 1
        
        let url = URL(string: "\(Constants.defaultBaseURL)/photos?page=\(lastLoadedPage)&per_page=10")!
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                if let error = error {
                    print("Error fetching photos: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data,
                      let photoResults = try? JSONDecoder().decode([PhotoResult].self, from: data) else {
                    print("Failed to decode photos")
                    return
                }
                
                let newPhotos = photoResults.map { Photo(from: $0) }
                self.photos.append(contentsOf: newPhotos)
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            }
        }
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(OAuth2TokenStorage().token ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let index = self.photos.firstIndex(where: { $0.id == photoId }) else {
                    completion(.failure(NSError(domain: "Image not found", code: 0, userInfo: nil)))
                    return
                }
                
                // Create a mutable copy of the Photo and update it
                var updatedPhoto = self.photos[index]
                updatedPhoto.isLiked.toggle()
                self.photos[index] = updatedPhoto
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                completion(.success(()))
            }
        }
        task.resume()
    }
}
