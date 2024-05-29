import ProgressHUD
import UIKit

final class UIBlockingProgressHUD {
    // MARK: - Public Methods
    
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


