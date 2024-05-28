//
//  UIBlockingProgressHUD.swift
//  TickPic
//
//  Created by Кирилл Марьясов on 18.05.2024.
//

import ProgressHUD
import UIKit

final class UIBlockingProgressHUD {
    static func show() {
        DispatchQueue.main.async {
            ProgressHUD.animate()
        }
    }

    static func dismiss() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
}


