//
//  UIBlockingProgressHUD.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 18.05.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        UIBlockingProgressHUD.show()
        window?.isUserInteractionEnabled = false
    }
    
    static func dismiss() {
        UIBlockingProgressHUD.dismiss()
        window?.isUserInteractionEnabled = true
    }
}


