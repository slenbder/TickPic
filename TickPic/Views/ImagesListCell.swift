import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!

    weak var delegate: ImagesListCellDelegate?
    private var isLoadingLike: Bool = false {
        didSet {
            likeButton.isUserInteractionEnabled = !isLoadingLike
        }
    }

    @IBAction private func likeButtonClicked() {
        guard !isLoadingLike else { return }
        delegate?.imageListCellDidTapLike(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        isLoadingLike = false
    }

    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }

    func setLoading(_ isLoading: Bool) {
        isLoadingLike = isLoading
    }
}
