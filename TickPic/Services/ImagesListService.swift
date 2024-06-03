import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private init() {}
    
    private var currentTask: URLSessionTask?
    private var lastLoadedPage = 0
    private(set) var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        if currentTask != nil { return }
        
        let nextPage = lastLoadedPage + 1
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos?page=\(nextPage)&per_page=10") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        currentTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.currentTask = nil
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(from: $0) }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
            }
        }
        currentTask?.resume()
    }
}
