import Foundation
import XCTest
@testable import TickPic

final class ProfileViewTests: XCTestCase {

  func testViewControllerCallsViewDidLoad() {

    let viewController = ProfileViewController()
    let presenter = ProfileViewPresenterSpy()
    viewController.presenter = presenter
    presenter.view = viewController

    presenter.viewDidLoad()

    XCTAssertTrue(presenter.viewDidLoadCalled)
  }

  func testViewControllerCallsNotificationObserver() {
    let viewController = ProfileViewController()
    let presenter = ProfileViewPresenterSpy()
    viewController.presenter = presenter
    presenter.view = viewController

    presenter.notificationObserver()

    XCTAssertTrue(presenter.notificationObserverCalled)
  }

  func testPresenterCallsDidTapLogoutButton() {
    let presenter = ProfileViewPresenterSpy()
    presenter.didTapLogoutButton()

    XCTAssertTrue(presenter.didTapLogoutButtonCalled)
  }

  func testViewControllerDidTapLogoutButtonCallsPresenter() {
    let viewController = ProfileViewController()
    let presenter = ProfileViewPresenterSpy()
    viewController.presenter = presenter
    presenter.view = viewController

    viewController.didTapLogoutButton(viewController.logoutButton)

    XCTAssertTrue(presenter.didTapLogoutButtonCalled)
  }
}
