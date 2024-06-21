import XCTest

final class TickPicUITests: XCTestCase {
  
  private let app = XCUIApplication() // переменная приложения
  
  override func setUpWithError() throws {
    continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
    app.launchArguments = ["UITEST"]
    app.launch() // запускаем приложение перед каждым тестом
  }


  func testAuth() throws {
    
    XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    app.buttons["Authenticate"].tap()
    
    let webView = app.webViews["UnsplashWebView"]
    XCTAssertTrue(webView.waitForExistence(timeout: 3))
    
    let loginTextField = webView.descendants(matching: .textField).element
    XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
    
    loginTextField.tap()
      loginTextField.typeText("")

    let passwordTextField = webView.descendants(matching: .secureTextField).element
    XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
    XCUIApplication().toolbars.buttons["Done"].tap()
    
    passwordTextField.tap()
    passwordTextField.typeText("")
    webView.tap()
    sleep(1)
    
    XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 3))
    webView.buttons["Login"].tap()
    
    
    let tableQuery = app.tables
    let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
    XCTAssertTrue(cell.waitForExistence(timeout: 10))
  }
  
  func testFeed() throws {
    let tablesQuery = app.tables
    sleep(2)
    tablesQuery.element.swipeUp()


    let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
    let likeButton = cellToLike.buttons["LikeButton"]
    likeButton.tap()
    sleep(5)
    likeButton.tap()
    sleep(5)
    cellToLike.tap()
    sleep(5)
    
    let image = app.scrollViews.images.element(boundBy: 0)
    image.pinch(withScale: 3, velocity: 1)
    image.pinch(withScale: 0.5, velocity: -1)
    
    let navBackButtonWhiteButton = app.buttons["BackButton"]
    navBackButtonWhiteButton.tap()
  }
  
  func testProfile() throws {
    app.tabBars.buttons.element(boundBy: 1).tap()
    
    XCTAssertTrue(app.staticTexts["Kirill Maryasov"].exists)
    XCTAssertTrue(app.staticTexts["@slenbder"].exists)
    sleep(2)
    app.buttons["logoutButton"].tap()
    sleep(2)
    let logoutAlert = app.alerts["Пока, пока!"]
    XCTAssertTrue(logoutAlert.exists, "Logout alert does not exist")
    logoutAlert.buttons["Да"].tap()
    XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    
  }
}
