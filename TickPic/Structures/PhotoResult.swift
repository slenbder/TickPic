import Foundation

// MARK: - UrlsResult
struct UrlsResult: Decodable {
    let thumb: String
    let full: String
}

// MARK: - PhotoResult
struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: UrlsResult
    let likedByUser: Bool
    let description: String?
    let createdAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id, width, height, urls
        case likedByUser = "liked_by_user"
        case description
        case createdAt = "created_at"
    }
}
