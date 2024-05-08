//
//  SplashViewController.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Проверяем наличие токена авторизации
        let tokenStorage = OAuth2TokenStorage()
        if tokenStorage.token != nil {
            // Если токен авторизации есть, переходим к экрану галереи
            switchToGalleryViewController()
        } else {
            // Если токена авторизации нет, переходим к экрану авторизации
            performSegue(withIdentifier: "showAuthenticationScreenSegueIdentifier", sender: nil)
        }
    }
    
    private func switchToGalleryViewController() {
        // Получаем экземпляр UITabBarController из сториборда
        guard let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
                fatalError("Failed to instantiate UITabBarController from storyboard")
        }
        
        // Устанавливаем главный таб-контроллер как корневой контроллер
        UIApplication.shared.windows.first?.rootViewController = tabBarController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAuthenticationScreenSegueIdentifier" {
            guard let navigationController = segue.destination as? UINavigationController,
                  let authViewController = navigationController.viewControllers.first as? AuthViewController else {
                fatalError("Failed to prepare for segue: showAuthenticationScreenSegueIdentifier")
            }
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        // Вызываем метод делегата для сообщения об успешной авторизации
        switchToGalleryViewController()
    }
}




