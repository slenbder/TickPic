import Foundation
import UIKit
@testable import TickPic

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationObserverCalled: Bool = false
    var didTapLogoutButtonCalled = true
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func notificationObserver() {
        notificationObserverCalled = true
    }
    
    func updateAvatar() {
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: TickPic.ProfileViewPresenterProtocol?
    var presentCalled = false
    
    func updateAvatar() {
    }
    
    func displayProfileData(name: String?, loginName: String?, bio: String?) {
    }
    
    func displayAvatar(image: UIImage?) {
        
    }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        
    }
}
