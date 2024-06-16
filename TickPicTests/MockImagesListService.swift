import Foundation
@testable import TickPic // Убедитесь, что имя вашего проекта указано правильно

class MockImagesListService: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    var changeLikePhotoId: String?
    var changeLikeIsLike: Bool?
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        changeLikePhotoId = photoId
        changeLikeIsLike = isLike
        completion(.success(()))
    }
}
