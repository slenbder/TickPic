//
//  SplashViewController.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//

import UIKit
import WebKit

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared // Используем синглтон

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token) // Вызов fetchProfile, если токен уже присутствует
        } else {
            performSegue(withIdentifier: "ShowAuthenticationScreen", sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAuthenticationScreen" {
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Failed to prepare for ShowAuthenticationScreen")
            }
            if let viewController = navigationController.viewControllers.first as? AuthViewController {
                viewController.delegate = self
            }
        }
    }

    // Новый метод для загрузки профиля
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.switchToTabBarController()
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            self?.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(with: code) { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.oauth2TokenStorage.token = accessToken
                self?.fetchProfile(accessToken) // Вызов fetchProfile после получения токена
            case .failure(let error):
                print("Error fetching OAuth2 token: \(error)")
            }
        }
    }
}




