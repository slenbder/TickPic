import UIKit
import Kingfisher

// MARK: - ImagesListCell

class ImagesListCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Configuration
    
    func config(with photo: Photo) {
        dateLabel.text = DateFormatter.localizedString(from: photo.createdAt ?? Date(), dateStyle: .long, timeStyle: .none)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: URL(string: photo.thumbImageURL), placeholder: UIImage(named: "placeholder"))
        
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
