import Foundation

struct UrlsResult: Codable {
  let raw: String
  let full: String
  let regular: String
  let small: String
  let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    var likedByUser: Bool?
    let description: String?
    let urls: UrlsResult
}
