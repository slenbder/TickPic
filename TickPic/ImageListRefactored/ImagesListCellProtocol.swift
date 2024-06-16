import Foundation

class MockImagesListCell: ImagesListCellProtocol {
    var delegate: ImagesListCellDelegate?
    
    var isLiked: Bool = false
    var likeButtonEnabled: Bool = true
    
    func setIsLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
    }
    
    func setLikeButtonEnabled(_ isEnabled: Bool) {
        likeButtonEnabled = isEnabled
    }
}
