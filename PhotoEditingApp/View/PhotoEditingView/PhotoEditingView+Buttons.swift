import UIKit

extension PhotoEditingView {

    @objc func mainButtonsTarget(_ sender: UIButton) {
        switch sender {
        case startButton:
            startAction?()
        case deleteButton:
            deleteAction?()
        case saveButton:
            saveAction?()
        default: break
        }
    }
}
