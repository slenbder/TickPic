import Foundation

// MARK: - ImagesListService
final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private let session = URLSession.shared
    private var lastLoadedPage: Int = 0
    private var isLoading: Bool = false
    private let baseURL = Constants.defaultBaseURL

    private init() {}
    
    // MARK: - Fetch Photos
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true
        lastLoadedPage += 1
        
        let url = baseURL.appendingPathComponent("/photos")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(lastLoadedPage)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        
        guard let requestURL = components?.url else {
            print("Error: Invalid URL")
            isLoading = false
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        session.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let photoResults):
                    let newPhotos = photoResults.map { Photo(from: $0) }
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                case .failure(let error):
                    print("Error fetching photos: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
