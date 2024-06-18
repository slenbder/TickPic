import Foundation

public protocol ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func configDate(from date: String) -> String?
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    private let imageListService: ImagesListService
    private let dateFormatter8601 = ISO8601DateFormatter()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    init(view: ImagesListViewControllerProtocol?, imageListService: ImagesListService = ImagesListService.shared) {
        self.view = view
        self.imageListService = imageListService
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    @objc private func updateTableViewAnimated() {
        view?.updateTableViewAnimated()
    }
    
    public func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    public func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photoId, isLike: isLiked) { result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                completion(result)
            }
        }
    }
    
    public func configDate(from date: String) -> String? {
        guard let date = dateFormatter8601.date(from: date) else { return nil }
        return dateFormatter.string(from: date)
    }
    
}
