import XCTest
@testable import TickPic

class ImagesListPresenterTests: XCTestCase {

    var presenter: ImagesListPresenter!
    var view: MockImagesListView!
    var service: MockImagesListService!
    
    override func setUp() {
        super.setUp()
        view = MockImagesListView()
        service = MockImagesListService()
        presenter = ImagesListPresenter(view: view, service: service)
    }
    
    override func tearDown() {
        presenter = nil
        service = nil
        view = nil
        super.tearDown()
    }
    
    func testFetchNextPage() {
        presenter.fetchNextPage()
        XCTAssertTrue(service.fetchPhotosNextPageCalled)
    }
    
    func testNumberOfPhotos() {
        service.photos = [Photo(id: "1", size: .zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: URL(string: "https://example.com")!, largeImageURL: URL(string: "https://example.com")!, fullImageURL: URL(string: "https://example.com")!, isLiked: false)]
        presenter.updatePhotos()
        XCTAssertEqual(presenter.numberOfPhotos(), 1)
    }
    
    func testPhotoAtIndex() {
        let photo = Photo(id: "1", size: .zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: URL(string: "https://example.com")!, largeImageURL: URL(string: "https://example.com")!, fullImageURL: URL(string: "https://example.com")!, isLiked: false)
        service.photos = [photo]
        presenter.updatePhotos()
        XCTAssertEqual(presenter.photo(at: 0).id, photo.id)
    }
    
    func testDidTapLikeButton() {
        let photo = Photo(id: "1", size: .zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: URL(string: "https://example.com")!, largeImageURL: URL(string: "https://example.com")!, fullImageURL: URL(string: "https://example.com")!, isLiked: false)
        service.photos = [photo]
        presenter.updatePhotos()
        
        let mockCell = MockImagesListCell()
        presenter.didTapLikeButton(at: 0, cell: mockCell)
        
        XCTAssertTrue(service.changeLikeCalled)
        XCTAssertEqual(service.changeLikePhotoId, photo.id)
        XCTAssertEqual(service.changeLikeIsLike, !photo.isLiked)
    }
}

class MockImagesListView: ImagesListView {
    var updateTableViewCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var updateCellCalled = false
    var updatedIndexPath: IndexPath?
    var updatedIsLiked: Bool?
    
    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func updateCell(at indexPath: IndexPath, with isLiked: Bool) {
        updateCellCalled = true
        updatedIndexPath = indexPath
        updatedIsLiked = isLiked
    }
}

class MockImagesListCell: ImagesListCellProtocol {
    var delegate: ImagesListCellDelegate?
    
    var isLiked: Bool = false
    var likeButtonEnabled: Bool = true
    
    func setIsLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
    }
    
    func setLikeButtonEnabled(_ isEnabled: Bool) {
        likeButtonEnabled = isEnabled
    }
}
