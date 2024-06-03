import Foundation

// MARK: - ImagesListService
final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage = 0
    private var isLoading = false
    
    init() {}
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        isLoading = true

        let nextPage = lastLoadedPage + 1
        let urlString = "\(Constants.defaultBaseURL)/photos?page=\(nextPage)&per_page=10"

        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.isLoading = false }

            if let data = data {
                do {
                    let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                    let newPhotos = photoResults.map { Photo(from: $0) }
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = nextPage
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    }
                } catch {
                    print("Failed to decode photos: \(error)")
                }
            } else if let error = error {
                print("Failed to fetch photos: \(error)")
            }
        }
        task.resume()
    }
}
