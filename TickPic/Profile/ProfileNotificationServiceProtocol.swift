import Foundation

protocol ProfileNotificationServiceProtocol {
    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?)
    func removeObserver(_ observer: Any, name: NSNotification.Name?, object: Any?)
}
