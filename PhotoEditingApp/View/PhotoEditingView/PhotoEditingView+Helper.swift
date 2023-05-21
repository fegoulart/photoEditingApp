import UIKit

extension PhotoEditingView {
    func setPhoto(_ image: UIImage?) {
        guard let image = image else {
            setImageConstraints(0)
            originalCIImage = nil
            return
        }
        defer {
            originalCIImage = CIImage(image: image)
            photoImageView.image = originalCIImage
        }
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
                self.resetControls()
                completion()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertView.addAction(actionCancel)
            alertView.addAction(actionOk)
            vc?.present(alertView, animated: true)
        }
    }

    func saveDecorated(with completion: @escaping (UIImage?)->(Void)) -> ()->(Void) {
        return { [weak self] in
            guard let self = self, photoImageView.image != nil else { return }
            let vc = self.getParentViewController()
            let alertView = UIAlertController(title: "Save warning", message: "Are you sure ?", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Yes", style: .default) { _ in
                guard let uiImage = self.photoImageView.toUIImage else { return }
                self.resetControls()
                completion(uiImage)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertView.addAction(actionCancel)
            alertView.addAction(actionOk)
            vc?.present(alertView, animated: true)
        }
    }

    private func resetControls() {
        saveButton.fadeOut()
        segmentControl.selectedSegmentIndex = -1
        brightnessButton.isSelected = false
        contrastButton.isSelected = false
        saturationButton.isSelected = false
        brightnessSlider.value = 0
        saturationSlider.value = 1
        contrastSlider.value = 1
    }
}
