import Foundation
import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
  func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
public protocol WebViewViewControllerProtocol: AnyObject {
  var presenter: WebViewPresenterProtocol? { get set }
  func load(request: URLRequest)
  func setProgressValue(_ newValue: Float)
  func setProgressHidden(_ isHidden: Bool)
}
final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
  func load(request: URLRequest) {
    webView.load(request)
  }

  var presenter: WebViewPresenterProtocol?

  @IBOutlet weak var webView: WKWebView!

  @IBOutlet weak var progressView: UIProgressView!

  weak var delegate: WebViewViewControllerDelegate?
  private var estimatedProgressObservation: NSKeyValueObservation?

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.navigationDelegate = self
    webView.accessibilityIdentifier = "UnsplashWebView"
    presenter?.viewDidLoad()
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
       options: [],
       changeHandler: { [weak self] _, _ in
         guard let self = self else { return }
         presenter?.didUpdateProgressValue(webView.estimatedProgress)
       })
  }

  func setProgressValue(_ newValue: Float) {
    progressView.progress = newValue
  }

  func setProgressHidden(_ isHidden: Bool) {
    progressView.isHidden = isHidden
  }

  @IBAction func didTapBackButton(_ sender: Any) {
    delegate?.webViewViewControllerDidCancel(self)
  }
}

extension WebViewViewController: WKNavigationDelegate {
  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    if let code = code(from: navigationAction) {
      delegate?.webViewViewController(self, didAuthenticateWithCode: code)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }

  private func code(from navigationAction: WKNavigationAction) -> String? {
    if let url = navigationAction.request.url {
      return presenter?.code(from: url)
    }
    return nil
  }
}
