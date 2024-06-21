import Foundation
@testable import TickPic
import UIKit


final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationObserverCalled: Bool = false
    var isLiked: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.isLiked = isLiked
            completion(.success(()))
        }
    }
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func configDate(from date: String) -> String? {
        let dateFormatter8601 = ISO8601DateFormatter()
        guard let date = dateFormatter8601.date(from: date) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: date)
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    var tableViewUpdatesCalled: Bool =  false
    
    func updateTableViewAnimated() {
        tableViewUpdatesCalled = true
    }
}
