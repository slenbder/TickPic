//import Foundation
//
//struct PhotoMapper {
//    private static let dateFormatter = ISO8601DateFormatter()
//    
//    static func map(from photoResult: PhotoResult) -> Photo {
//        let createdAt = dateFormatter.date(from: photoResult.createdAt)
//        
//        let thumbImageURL = URL(string: photoResult.urls.thumb)!
//        let largeImageURL = URL(string: photoResult.urls.full)!
//        let fullImageURL = URL(string: photoResult.urls.full)!
//        
//        return Photo(
//            id: photoResult.id,
//            size: CGSize(width: photoResult.width, height: photoResult.height),
//            createdAt: createdAt,
//            welcomeDescription: photoResult.description,
//            thumbImageURL: thumbImageURL,
//            largeImageURL: largeImageURL,
//            fullImageURL: fullImageURL,
//            isLiked: photoResult.likedByUser
//        )
//    }
//}
