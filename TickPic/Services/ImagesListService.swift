import Foundation

final class ImagesListService {

    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private init() {}

    private var currentTask: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage = 0
    private var isLoading = false
    private var loadedPhotoIDs: Set<String> = []

    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true
        
        let nextPage = lastLoadedPage + 1
        let urlString = "\(Constants.defaultBaseURL)/photos?page=\(nextPage)"
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(from: $0) }.filter { !self.loadedPhotoIDs.contains($0.id) }
                self.loadedPhotoIDs.formUnion(newPhotos.map { $0.id })
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
                
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }.resume()
    }
    
    func getPhotos() -> [Photo] {
        return photos
    }
}
