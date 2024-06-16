import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}
