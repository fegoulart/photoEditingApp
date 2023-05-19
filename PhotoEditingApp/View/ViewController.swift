import UIKit
import Combine

final class ViewController: UIViewController {

    var imagePicker: ImagePicker
    let photoEditingView: PhotoEditingView
    let viewModel: ViewModel
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        self.view = photoEditingView
        super.viewDidLoad()
        DispatchQueue.global().async {
            self.viewModel.retrieveImage()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        view: PhotoEditingView,
        imagePicker: ImagePicker,
        viewModel: ViewModel
    ) {
        self.imagePicker = imagePicker
        self.photoEditingView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        subscribeToImage()
    }

    private func subscribeToImage() {
        cancellable = viewModel.$imageData.sink { imageData in
            guard let imageData: Data = imageData else { self.photoEditingView.photoImageView.image = nil ; return }
            assert(!Thread.isMainThread)
            DispatchQueue.global().async {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.photoEditingView.photoImageView.image = image
                    }
                }
            }
        }
    }
}

extension ViewController: ImagePickerDelegate {
    func didSelect<UIImage>(_ image: UIImage?) {
        guard let image: UIKit.UIImage = image as? UIKit.UIImage else { return }
        photoEditingView.photoImageView.image = image
        guard let pngData = image.pngData() else { return }
        DispatchQueue.global().async {
            self.viewModel.cacheImage(pngData)

// MARK: - States

extension ViewController {
    func setEmptyState() {
        DispatchQueue.main.async {
            self.photoEditingView.setPhoto(nil)
            self.photoEditingView.photoImageView.isHidden = true
            self.photoEditingView.startButton.isHidden = false
            self.photoEditingView.segmentControl.isHidden = true
            self.photoEditingView.deleteButton.isHidden = true
        }
    }

    func setEditingState(with image: UIImage) {
        DispatchQueue.main.async {
            self.photoEditingView.photoImageView.isHidden = false
            self.photoEditingView.startButton.isHidden = true
            self.photoEditingView.segmentControl.isHidden = false
            self.photoEditingView.deleteButton.isHidden = false
            self.photoEditingView.setPhoto(image)
        }
    }
}
