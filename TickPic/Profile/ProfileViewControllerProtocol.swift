import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(profile: Profile)
    func updateAvatar(url: URL)
}
