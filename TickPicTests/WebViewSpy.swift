import TickPic
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    var presenter: TickPic.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) { }

    func code(from url: URL) -> String? {
        return nil
    }

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
