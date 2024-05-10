//
//  SplashViewController.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 08.05.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    let tokenStorage = OAuth2TokenStorage.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if tokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "showAuthenticationScreenSegueIdentifier", sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
                fatalError("Failed to instantiate UITabBarController from storyboard")
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController = tabBarController
        }
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
        switchToTabBarController()
    }
}




