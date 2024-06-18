//import Foundation
//
//protocol ProfileNotificationServiceProtocol {
//    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?)
//    func removeObserver(_ observer: Any, name: NSNotification.Name?, object: Any?)
//}
//
//final class ProfileNotificationService: ProfileNotificationServiceProtocol {
//    static let shared = ProfileNotificationService()
//    
//    private init() { }
//    
//    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?) {
//        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
//    }
//    
//    func removeObserver(_ observer: Any, name: NSNotification.Name?, object: Any?) {
//        NotificationCenter.default.removeObserver(observer, name: name, object: object)
//    }
//}
