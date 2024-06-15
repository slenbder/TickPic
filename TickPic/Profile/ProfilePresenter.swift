import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    

    init(profileService: ProfileService = .shared, profileImageService: ProfileImageService = .shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }

    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
        updateAvatar()
    }

    func updateAvatar() {
        guard let username = profileService.profile?.username else { return }
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            switch result {
            case .success(let urlString):
                if let url = URL(string: urlString) {
                    self?.view?.updateAvatar(url: url)
                }
            case .failure(let error):
                print("Error fetching profile image URL: \(error)")
            }
        }
    }
}
