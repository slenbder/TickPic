import UIKit
import Kingfisher

class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!

    func config(with imageURL: String) {
        cellImage.kf.indicatorType = .activity
        let placeholderImage = UIImage(named: "StubPic")
        
        // Установка заглушки перед загрузкой изображения
        cellImage.image = placeholderImage
        
        cellImage.kf.setImage(
            with: URL(string: imageURL),
            placeholder: placeholderImage,
            options: [.transition(.fade(0.2))]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = UIImage(named: "StubPic")
    }
}
