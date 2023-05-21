import UIKit
import Combine

final class ViewController: UIViewController {

    var imagePicker: ImagePicker
    let photoEditingView: PhotoEditingView
    let viewModel: ViewModel
    var cancellable: AnyCancellable?
    var messageCancellable: AnyCancellable?
    let stateChangeManager: StateChangeManager

    override func viewDidLoad() {
        self.view = photoEditingView
        super.viewDidLoad()
        checkImageCache()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        view: PhotoEditingView,
        imagePicker: ImagePicker,
        viewModel: ViewModel,
        stateChangeManager: StateChangeManager
    ) {
        self.imagePicker = imagePicker
        self.photoEditingView = view
        self.viewModel = viewModel
        self.stateChangeManager = stateChangeManager
        super.init(nibName: nil, bundle: nil)
        subscribeToImage()
        subscribeToOperationResult()
    }

    private func subscribeToImage() {
        self.photoEditingView.setPhoto(nil)
        cancellable = viewModel.$imageData.dropFirst(1).sink { imageData in
            guard let imageData: Data = imageData else { self.setEmptyState(); return }
            assert(!Thread.isMainThread)
            if let image = UIImage(data: imageData){
                self.setEditingState(with: image)
            }
        }
    }

    private func subscribeToOperationResult() {
        messageCancellable = viewModel.$operationResult.dropFirst().sink { resultString in
            guard !resultString.isEmpty else { return }
            let alertController = UIAlertController(title: "Operation status", message: resultString, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in }
            alertController.addAction(actionOk)
            self.present(alertController, animated: true)
        }
    }

    private func checkImageCache() {
        self.viewModel.retrieveImage()
    }
}

extension ViewController: ImagePickerDelegate {
    func didSelect<UIImage>(_ image: UIImage?) {
        guard let image: UIKit.UIImage = image as? UIKit.UIImage else { return }
        setEditingState(with: image)
        guard let pngData = image.pngData() else { return }
        viewModel.cacheImage(pngData)
    }
}

// MARK: - States

extension ViewController {
    func setEmptyState() {
        stateChangeManager.setNewState { [weak self] in
            guard let self = self else { return }
            assert(Thread.isMainThread)
            self.photoEditingView.photoImageView.fadeOut()
            self.photoEditingView.startButton.fadeIn()
            self.photoEditingView.segmentControl.fadeOut()
            self.photoEditingView.adjustsStackView.fadeOut()
            self.photoEditingView.contrastSlider.fadeOut()
            self.photoEditingView.brightnessSlider.fadeOut()
            self.photoEditingView.saturationSlider.fadeOut()
            self.photoEditingView.deleteButton.fadeOut {
                self.photoEditingView.setPhoto(nil)
                self.stateChangeManager.signal()
            }
        }
    }

    func setEditingState(with image: UIImage) {
        stateChangeManager.setNewState { [weak self] in
            guard let self = self else { return }
            assert(Thread.isMainThread)
            self.photoEditingView.photoImageView.fadeIn()
            self.photoEditingView.startButton.fadeOut()
            self.photoEditingView.segmentControl.fadeIn()
            self.photoEditingView.deleteButton.fadeIn {
                self.photoEditingView.setPhoto(image)
                self.stateChangeManager.signal()
            }
        }
    }
}
