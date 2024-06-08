import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageURL: String  // Новое поле
    var isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.fullImageURL = photoResult.urls.full  // Инициализация нового поля
        self.isLiked = photoResult.likedByUser
        
        let dateFormatter = ISO8601DateFormatter()
        self.createdAt = dateFormatter.date(from: photoResult.createdAt)
    }
}
