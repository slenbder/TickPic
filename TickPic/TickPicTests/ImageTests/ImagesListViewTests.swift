import Foundation
import XCTest
@testable import TickPic

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testUpdateTableViewAnimated() {
        
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        
        viewController.updateTableViewAnimated()
        
        XCTAssertTrue(viewController.tableViewUpdatesCalled)
    }
    
    func testChangeLike() {
        
        let expectation = XCTestExpectation(description: "Change like")
        let presenter = ImagesListViewPresenterSpy()
        
        presenter.changeLike(photoId: "PhotoId", isLiked: true) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(presenter.isLiked)
    }
    func testFetchPhotosNextPage() {
        let presenter = ImagesListViewPresenterSpy()
        presenter.fetchPhotosNextPage()
        
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testConfigDate() {
        let presenter = ImagesListViewPresenterSpy()
        let date = "1998-10-16T17:35:56Z"
        let formattedDate = presenter.configDate(from: date)
        
        XCTAssertEqual(formattedDate, "16 октября 1998", "Date should be formatted correctly")
    }
}

