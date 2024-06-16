import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListCellProtocol: AnyObject {
    var delegate: ImagesListCellDelegate? { get set }
    func setIsLiked(_ isLiked: Bool)
    func setLikeButtonEnabled(_ isEnabled: Bool)
}

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func setLikeButtonEnabled(_ isEnabled: Bool) {
        likeButton.isUserInteractionEnabled = isEnabled
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = UIImage(named: "StubPic")
        setIsLiked(false)
    }
}
