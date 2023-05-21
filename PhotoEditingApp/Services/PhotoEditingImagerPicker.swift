import UIKit

final class PhotoEditingImagePicker: NSObject, ImagePicker {
    weak var delegate: ImagePickerDelegate?

    let pickerController: UIImagePickerController
    let pickerViewModel: ImagePickerViewModel 
    weak var presentationController: UIViewController?

    init(
        pickerController: UIImagePickerController,
        pickerViewModel: ImagePickerViewModel
    ) {
        self.pickerController = pickerController
        self.pickerViewModel = pickerViewModel
        super.init()
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        pickerController.delegate = self
    }

    func present() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        pickerViewModel.checkPermission(for: .camera) { [weak self] isCameraAllowed in
            if isCameraAllowed {
                if let action = self?.action(for: .camera, title: "Take photo") {
                    DispatchQueue.main.async {
                        alertController.addAction(action)
                    }
                }
            }
            self?.pickerViewModel.checkPermission(for: .photoLibrary) { [weak self] isPhotoLibraryAllowed in
                DispatchQueue.main.async {
                    if isPhotoLibraryAllowed {
                        if let action = self?.action(for: .photoLibrary, title: "Photo library") {
                            alertController.addAction(action)
                        }
                    }
                    guard !alertController.actions.isEmpty else {
                        self?.alertPermissionsNeeded()
                        return
                    }
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self?.presentationController?.present(alertController, animated: true)
                }
            }

        }
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    private func alertPermissionsNeeded() {
        guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else { return }

        let alert = UIAlertController(
            title: "Need Photos and Camera Access",
            message: "Photos and Camera accesses are required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Photos & Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))

        self.presentationController?.present(alert, animated: true, completion: nil)
    }
}

extension PhotoEditingImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
           return self.pickerController(picker, didSelect: nil)
       }
        self.pickerController(picker, didSelect: image)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.didSelect(image)
    }
}

extension PhotoEditingImagePicker: UINavigationControllerDelegate { }
