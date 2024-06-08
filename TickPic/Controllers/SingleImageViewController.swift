import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    var imageUrl: URL?
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0 // Увеличиваем максимальный масштаб
        scrollView.delegate = self
        imageView.contentMode = .scaleAspectFit // Устанавливаем режим контента
        loadImage()
    }
    
    private func loadImage() {
        guard let imageUrl = imageUrl else { return }
        
        ProgressHUD.animate()
        
        imageView.kf.setImage(with: imageUrl, completionHandler: { [weak self] result in
            
            ProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.rescaleAndCenterImageInScrollView(image: value.image)
            case .failure(let error):
                print("Error loading image: \(error)")
                self.showError()
            }
        })
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let scale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = scale
        
        imageView.frame.size = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        
        centerImageInScrollView()
    }
    
    private func centerImageInScrollView() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let horizontalPadding = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalPadding = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .default))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        })
        present(alert, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
