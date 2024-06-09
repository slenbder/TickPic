import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    internal var photos: [Photo] = []
    private let tokenStorage = OAuth2TokenStorage()
    private var currentPage = 1  // добавляем переменную для отслеживания текущей страницы
    private var isFetchingPhotos = false  // переменная для предотвращения одновременных запросов

    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        guard let token = tokenStorage.token else {
            print("No token found")
            return
        }
        
        guard !isFetchingPhotos else { return }  // если уже идет запрос, то выходим
        
        isFetchingPhotos = true
        
        var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "per_page", value: "10")  // запрашиваем по 10 фото за раз
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.data(for: request) { [weak self] result in
            guard let self = self else { return }
            self.isFetchingPhotos = false  // сбрасываем флаг после завершения запроса
            
            switch result {
            case .success(let data):
                do {
                    let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                    self.photos.append(contentsOf: photoResults.map { Photo(from: $0) })
                    self.currentPage += 1  // увеличиваем номер страницы
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                } catch {
                    print("Failed to decode photos: \(error)")
                }
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
            }
        }
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            completion(.failure(NetworkError.urlRequestError(NSError(domain: "No token found", code: 0, userInfo: nil))))
            return
        }
        
        let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? "POST" : "DELETE"
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
        currentPage = 1  // сбрасываем номер страницы
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }
}
