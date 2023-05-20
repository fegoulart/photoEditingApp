import UIKit

extension PhotoEditingView {
    func showAdjusts() {
        DispatchQueue.main.async {
            self.adjustsStackView.fadeIn()
        }
    }
    
    func showFilters() {
        DispatchQueue.main.async {
            self.adjustsStackView.fadeOut()
        }
    }
}
