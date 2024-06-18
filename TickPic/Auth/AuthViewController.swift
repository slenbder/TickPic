import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
  
  weak var delegate: AuthViewControllerDelegate?

  private let showWebViewSegueIdentifier = "ShowWebView"


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showWebViewSegueIdentifier {
      guard
        let webViewViewController = segue.destination as? WebViewViewController
      else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
        return
      }
      let authHelper = AuthHelper()
      let webViewPresenter = WebViewPresenter(authHelper: authHelper)
      webViewViewController.presenter = webViewPresenter
      webViewPresenter.view = webViewViewController
      webViewViewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
     vc.dismiss(animated: true)
    UIBlockingProgressHUD.show()

     OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
       guard let self = self else { return }
       UIBlockingProgressHUD.dismiss()
       switch result {
       case .success(let token):
         print("Successfully fetched OAuth token:", token)
         self.delegate?.authViewController(self, didAuthenticateWithCode: token)
       case .failure(let error):
         print("Failed to fetch OAuth token:", error)
         self.showAlert()
       }
     }
   }

  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }

  private func showAlert() {
          let alert = UIAlertController(
              title: "Что-то пошло не так(",
              message: "Не удалось войти в систему",
              preferredStyle: .alert
          )
          alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
}
