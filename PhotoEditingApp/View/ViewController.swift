import UIKit
import MetalKit
import Combine

final class ViewController: UIViewController {

    var imagePicker: ImagePicker
    let photoEditingView: PhotoEditingView
    let viewModel: ViewModel
    private var cancellable: AnyCancellable?
    private var messageCancellable: AnyCancellable?
    private var filterButtonCancellable: AnyCancellable?
    let stateChangeManager: StateChangeManager
    lazy var dataSource = UICollectionViewDiffableDataSource<Int, PhotoEditingFilter>(
        collectionView: photoEditingView.filtersCollectionView
    ) { [weak photoEditingView] (collectionView, indexPath, item) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterCell.cellId,
            for: indexPath
        ) as? FilterCell
        cell?.configure(image: photoEditingView?.currentCIImage, with: item)
        return cell
    }

    lazy var snapshot: NSDiffableDataSourceSnapshot<Int, PhotoEditingFilter> = {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoEditingFilter>()
        snapshot.appendSections([0])
        return snapshot
    }()


    override func viewDidLoad() {
        self.view = photoEditingView
        super.viewDidLoad()
        checkImageCache()
        setupCollectionView()
        photoEditingView.filtersCollectionView.delegate = self
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
        subscribeToFilterButton()
    }

    private func subscribeToImage() {
        self.photoEditingView.setPhoto(nil)
        cancellable = viewModel.$imageData.dropFirst(1).sink { [weak self] imageData in
            guard let imageData: Data = imageData else { self?.setEmptyState(); return }
            assert(!Thread.isMainThread)
            if let image = UIImage(data: imageData){
                self?.setEditingState(with: image)
            }
        }
    }

    private func subscribeToOperationResult() {
        messageCancellable = viewModel.$operationResult.dropFirst().sink { [weak self] resultString in
            guard !resultString.isEmpty else { return }
            let alertController = UIAlertController(title: "Operation status", message: resultString, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in }
            alertController.addAction(actionOk)
            self?.present(alertController, animated: true)
        }
    }

    private func subscribeToFilterButton() {
        filterButtonCancellable = photoEditingView.$filteredSelected.sink { [weak self] isSelected in
            guard isSelected, let self = self else { return }
            self.setupCollectionView()
        }
    }

    private func cleanCollectionView() {
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections([0])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }

    private func checkImageCache() {
        self.viewModel.retrieveImage()
    }

    private func setupCollectionView() {
        self.cleanCollectionView()
        photoEditingView.filtersCollectionView.dataSource = dataSource
        PhotoEditingFilter.allCases.forEach { item in
            snapshot.appendItems([item], toSection: 0)
        }
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
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

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterName = PhotoEditingFilter.allCases[indexPath.row].rawValue
        let filter = CIFilter(name: filterName)
        filter?.setValue(self.photoEditingView.currentCIImage, forKey: kCIInputImageKey)
        if let ciimage = filter?.outputImage {
            photoEditingView.photoImageView.image = ciimage
        }
        photoEditingView.currentFilter = filter
    }
}
