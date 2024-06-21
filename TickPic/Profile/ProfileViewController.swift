import Kingfisher
import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func displayAvatar(image: UIImage?)
    func displayProfileData(name: String?, loginName: String?, bio: String?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private let profileService = ProfileService.shared
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .avatar)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var presenter: ProfileViewPresenterProtocol?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Billy Herrington"
        label.textColor = .white
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@dungeon_master"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, gay!"
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    let logoutButton: UIButton = {
      let button = UIButton.systemButton(
        with: UIImage(named: "Exit Button")!,
        target: self,
        action: #selector(Self.didTapLogoutButton)
      )
      button.tintColor = .red
      button.accessibilityIdentifier = "logoutButton"
      return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [avatarImageView,
         nameLabel,
         userNameLabel,
         descriptionLabel,
         logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        avatarSet()
        nameLabelSet()
        userNameLabelSet()
        descriptionLabelSet()
        logoutButtonSet()
        view.backgroundColor = .ypBlack
        presenter = ProfileViewPresenter(view: self)
        presenter?.viewDidLoad()
    }
    
    private func avatarSet() {
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func nameLabelSet() {
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func userNameLabelSet() {
        userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func descriptionLabelSet() {
        descriptionLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func logoutButtonSet() {
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
    }
    
    func displayAvatar(image: UIImage?) {
        avatarImageView.image = image
    }
    
    func displayProfileData(name: String?, loginName: String?, bio: String?) {
        nameLabel.text = name
        userNameLabel.text = loginName
        descriptionLabel.text = bio
    }
    
    @objc
    func didTapLogoutButton(_ sender: Any) {
        presenter?.didTapLogoutButton()
    }
}
