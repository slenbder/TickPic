import UIKit

// MARK: - SplashViewController

final class SplashViewController: UIViewController {

    // MARK: - Properties
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    // MARK: - UI Elements
    
    private let splashScreenLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Vector"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleToken()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(splashScreenLogo)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashScreenLogo.widthAnchor.constraint(equalToConstant: 72.52),
            splashScreenLogo.heightAnchor.constraint(equalToConstant: 75.11)
        ])
    }

    private func handleToken() {
        if let token = oauth2TokenStorage.token {
            fetchProfile(token)
        } else {
            presentAuthViewController()
        }
    }

    private func switchToTabBarController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarController")
            window.rootViewController = tabBarController
        }
    }

    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("Failed to instantiate AuthViewController")
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }

    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                self?.switchToTabBarController()
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(with: code) { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.oauth2TokenStorage.token = accessToken
                self?.fetchProfile(accessToken)
            case .failure(let error):
                print("Error fetching OAuth2 token: \(error)")
            }
        }
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            self?.fetchOAuthToken(code)
        }
    }
}
