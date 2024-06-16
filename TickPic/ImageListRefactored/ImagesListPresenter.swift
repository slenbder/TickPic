import Foundation

protocol ImagesListView: AnyObject {
    func updateTableView()
    func showLoading()
    func hideLoading()
    func updateCell(at indexPath: IndexPath, with isLiked: Bool)
}

final class ImagesListPresenter {
    
    private weak var view: ImagesListView?
    private let imagesListService: ImagesListServiceProtocol
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListView, service: ImagesListServiceProtocol) {
        self.view = view
        self.imagesListService = service
        setupObservers()
    }
    
    deinit {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func setupObservers() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updatePhotos()
        }
    }
    
    private func updatePhotos() {
        photos = imagesListService.photos
        view?.updateTableView()
    }
    
    func fetchNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func numberOfPhotos() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func didTapLikeButton(at index: Int, cell: ImagesListCell) {
        let photo = photos[index]
        view?.showLoading()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success:
                    self?.photos[index].isLiked.toggle()
                    self?.view?.updateCell(at: IndexPath(row: index, section: 0), with: self?.photos[index].isLiked ?? false)
                case .failure(let error):
                    print("Failed to change like: \(error.localizedDescription)")
                }
                cell.setLikeButtonEnabled(true)
            }
        }
    }
}
