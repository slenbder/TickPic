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
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
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
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        
    }
}
