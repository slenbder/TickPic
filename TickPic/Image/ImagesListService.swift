import Foundation


final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage()
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    init() {}
    
    func makePhotoRequest(page: Int, per_page: Int) -> URLRequest? {
        let baseURL = Constants.defaultBaseURL
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = "/photos"
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(per_page)"),
            URLQueryItem(name: "client_id", value: Constants.accessKey),
        ]
        
        guard let url = components?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let baseURL = Constants.defaultBaseURL.appendingPathComponent("photos/\(photoId)/like")
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
        task.resume()
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotoRequest(page: nextPage, per_page: 10) else {
            return
        }
        
        let task = urlSession.objectTask(for: request){ [weak self] (result: Result<[PhotoResult], Error>)  in
            guard let self else { return }
            switch result {
            case .success(let responsePhoto):
                let newPhoto = responsePhoto.map { Photo(photoResult: $0) }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhoto)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            case .failure(let error):
                print("ImagesListService: AuthServiceError - \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
}
extension ImagesListService {
    func clearImagesData() {
        self.photos = []
        self.lastLoadedPage = nil
    }
}
