import Foundation
import Kingfisher
import UIKit

public protocol ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateAvatar()
    func notificationObserver()
    func didTapLogoutButton()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let avatarImageView = UIImageView(image: .avatar)
    
    init(view: ProfileViewControllerProtocol?) {
        self.view = view
        notificationObserver()
    }
    
    func viewDidLoad() {
        notificationObserver()
        updateAvatar()
        view?.displayProfileData(name: ProfileService.shared.profile?.name,
                                 loginName: ProfileService.shared.profile?.loginName,
                                 bio: ProfileService.shared.profile?.bio)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                self.view?.displayAvatar(image: value.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    func notificationObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Нет", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
        })
        alert.view.accessibilityIdentifier = "logoutAlert"
        view?.present(alert, animated: true, completion: nil)
    }
}
