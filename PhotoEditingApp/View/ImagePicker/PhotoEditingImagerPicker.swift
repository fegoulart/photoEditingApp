import UIKit

final class PhotoEditingImagePicker: NSObject, ImagePicker {
    weak var delegate: ImagePickerDelegate?

    let pickerController: UIImagePickerController
    weak var presentationController: UIViewController?

    init(pickerController: UIImagePickerController) {
        self.pickerController = pickerController
        super.init()
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        pickerController.delegate = self
    }

    func present() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.presentationController?.present(alertController, animated: true)
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
