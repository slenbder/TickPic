import Foundation
import WebKit

final class ProfileLogoutService {
  static let shared = ProfileLogoutService()

  private init() { }

  func logout() {
    cleanCookies()
    clearProfileData()
    navigateToAuthScreen()
  }

  private func cleanCookies() {
    // Очищаем все куки из хранилища
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    // Запрашиваем все данные из локального хранилища
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      // Массив полученных записей удаляем из хранилища
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }

  private func clearProfileData() {
    ProfileService.shared.clearProfileData()
    ProfileImageService.shared.clearProfileImage()
    ImagesListService.shared.clearImagesData()
    OAuth2TokenStorage().clearToken()
  }
  private func navigateToAuthScreen() {
    guard let window = UIApplication.shared.windows.first else { return }
 //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //   let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
    window.rootViewController = SplashViewController()
    window.makeKeyAndVisible()
  }
}

