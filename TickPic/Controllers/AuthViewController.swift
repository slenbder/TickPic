//
//  AuthViewController.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 07.05.2024.
//

import UIKit
import WebKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            if let webViewViewController = segue.destination as? WebViewViewController {
                webViewViewController.delegate = self
            } else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("No available window to set root view controller")
        }
        
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {
            fatalError("Failed to instantiate TabBarController")
        }
        
        window.rootViewController = tabBarController
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(with: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let accessToken):
                self?.profileService.fetchProfile(accessToken) { profileResult in
                    switch profileResult {
                    case .success:
                        DispatchQueue.main.async {
                            self?.switchToTabBarController()
                        }
                    case .failure(let error):
                        print("Failed to fetch profile: \(error)")
                    }
                }
            case .failure(let error):
                print("Failed to obtain access token: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}



