import Foundation

// MARK: - UserResult

struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
