import UIKit

extension PhotoEditingView {
    func showAdjusts() {
        UIView.animate(withDuration: 1.0) {
            self.adjustsStackView.isHidden = false
        }
    }
}
