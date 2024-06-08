import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }

   func logout() {
      cleanCookies()
      clearWebViewData()
      clearToken()
      clearProfileData()
      reloadWebView()
   }

   private func cleanCookies() {
      print("Cleaning cookies...")
      // Очищаем все куки из хранилища
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
         print("Cookies cleaned.")
      }
   }

   private func clearWebViewData() {
       print("Clearing web view data...")
       let websiteDataTypes = Set([WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeIndexedDBDatabases, WKWebsiteDataTypeWebSQLDatabases])
       let date = Date(timeIntervalSince1970: 0)
       
       WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date) {
           print("Web view data cleared.")
       }
   }

   private func clearToken() {
      print("Clearing token...")
      let tokenStorage = OAuth2TokenStorage()
      tokenStorage.token = nil
      print("Token cleared.")
   }

   private func clearProfileData() {
      print("Clearing profile data...")
      ProfileService.shared.clearProfile()
      ProfileImageService.shared.clearAvatarURL()
      ImagesListService.shared.clearPhotos()
      print("Profile data cleared.")
   }

   private func reloadWebView() {
       let webView = WKWebView()
       webView.load(URLRequest(url: URL(string: "about:blank")!))
       print("WebView reloaded.")
   }
}
