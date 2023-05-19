import UIKit

extension PhotoEditingView {
    func setPhoto(_ image: UIImage?) {
        photoImageView.image = image
        guard let image = image else { setImageConstraints(0); return }
        let ratio = image.size.width / image.size.height
        let newHeight = photoImageView.frame.width / ratio
        setImageConstraints(newHeight)
    }

    func deleteDecorated(with completion: @escaping ButtonHandler) -> ButtonHandler {
        return { [weak self] in
            guard let self = self else { return }
            let vc = self.getParentViewController()
            let alertView = UIAlertController(title: "Delete warning", message: "Are you sure ?", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Yes", style: .destructive) { _ in
                completion()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertView.addAction(actionCancel)
            alertView.addAction(actionOk)
            vc?.present(alertView, animated: true)
        }
    }
}
