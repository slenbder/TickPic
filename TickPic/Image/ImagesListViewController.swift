import Foundation
import UIKit

public protocol ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol? { get set }
    
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    
    private let showSingleImageSegueController = "ShowSingleImage"
    
    @IBOutlet private weak var tableView: UITableView!
    
    var photos: [Photo] = []
    let imageListService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter = ImagesListViewPresenter(view: self)
        presenter?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewAnimated), name: ImagesListService.didChangeNotification, object: nil)
        imageListService.fetchPhotosNextPage()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc internal func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueController {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let photo = photos[indexPath.row]
            viewController.imageURL = URL(string: photo.fullImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let image = photos[indexPath.row]
        cell.dateLabel.text = presenter?.configDate(from: image.createdAt ?? "")
        let likeImage = image.isLiked ? "like_button_on" : "like_button_off"
        cell.likeButton.accessibilityIdentifier = "LikeButton"
        cell.likeButton.setImage(UIImage(named: likeImage), for: .normal)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: URL(string: image.largeImageURL), placeholder: UIImage(named: "Stub"))
        cell.delegate = self
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1,
           !ProcessInfo.processInfo.arguments.contains("UITest")
        {
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueController, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let isLike = !photo.isLiked
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: isLike) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    if let index = self?.photos.firstIndex(where: { $0.id == photo.id }) {
                        self?.photos[index].isLiked = isLike
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Failed to change like status: \(error)")
            }
        }
    }
}
