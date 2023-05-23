import Foundation

import UIKit
import MetalKit

final class PhotoEditingView: UIView {

    typealias ButtonHandler = () -> ()
    @Published var filteredSelected: Bool = false

    var segmentHeight: CGFloat { 44 }
    var defaultMargin: CGFloat { 20 }
    var largeButtonSize: CGPoint { CGPoint(x: 100, y: 100) }
    var defaultButtonSize: CGPoint { CGPoint(x: 44, y: 44) }
    var iphoneSE22Width: CGFloat { 375 }
    var currentCIImage: CIImage? = nil {
        didSet {
            guard currentCIImage != nil else { return }
            self.currentFilter?.setValue(currentCIImage, forKey: kCIInputImageKey)
            self.photoImageView.image = currentCIImage
            self.photoImageView.setNeedsDisplay()
        }
    }
    var outputCIImage: CIImage? {
        currentFilter?.outputImage
    }

    var currentFilter: CIFilter?

    var margins: UILayoutGuide {
        self.layoutMarginsGuide
    }

    var screenWidth: CGFloat? {
        let bounds = UIScreen.main.bounds
        return bounds.size.width
    }

    var screenHeight: CGFloat? {
        let bounds = UIScreen.main.bounds
        return bounds.size.height
    }

    var startAction: ButtonHandler?
    private(set) var deleteAction: ButtonHandler?
    private(set) var saveAction: (() -> ())?

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Filters", at: 0, animated: true)
        segment.insertSegment(withTitle: "Adjusts", at: 1, animated: true)
        segment.selectedSegmentTintColor = .blue
        segment.backgroundColor = .darkGray
        segment.addTarget(self, action: #selector(segmentTarget), for: .valueChanged)
        return segment
    }()

    @objc func segmentTarget(_ sender: UISegmentedControl) {
        assert(sender === segmentControl, "Only segmentControl should call this method")
        if sender.selectedSegmentIndex == 0 {
            self.showFilters()
        } else {
            self.showAdjusts()
        }
    }

    lazy var startButton: UIButton = {
        let image = UIImage(systemName: "plus.circle", withConfiguration:  UIImage.SymbolConfiguration(pointSize: self.largeButtonSize.y))
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(mainButtonsTarget), for: .touchUpInside)
        button.isHidden = true
        return button

    }()

    lazy var photoImageView: MetalView = {
        let imageView = MetalView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    lazy var deleteButton: UIButton = {
        let image = UIImage(systemName: "trash.circle", withConfiguration:  UIImage.SymbolConfiguration(pointSize: self.defaultButtonSize.y))
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(mainButtonsTarget), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    lazy var saveButton: UIButton = {
        let image = UIImage(systemName: "folder.circle", withConfiguration:  UIImage.SymbolConfiguration(pointSize: self.defaultButtonSize.y))
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(mainButtonsTarget), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    lazy var brightnessIcon: UIImage = {
        UIImage(named: "brightness")!
    }()

    lazy var brightnessButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: defaultButtonSize.x, height: defaultButtonSize.y)
        button.setBackgroundImage(brightnessIcon.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        button.setBackgroundImage(brightnessIcon.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(adjustSelected), for: .touchUpInside)
        return button
    }()

    lazy var saturationIcon: UIImage = {
        UIImage(named: "saturation")!
    }()

    lazy var saturationButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: defaultButtonSize.x, height: defaultButtonSize.y)
        button.setBackgroundImage(saturationIcon.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        button.setBackgroundImage(saturationIcon.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(adjustSelected), for: .touchUpInside)
        return button
    }()

    lazy var contrastIcon: UIImage = {
        UIImage(named: "contrast")!
    }()

    lazy var contrastButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: defaultButtonSize.x, height: defaultButtonSize.y)
        button.setBackgroundImage(contrastIcon.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        button.setBackgroundImage(contrastIcon.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(adjustSelected), for: .touchUpInside)
        return button
    }()

    lazy var contrastSlider: UISlider = {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: margins.layoutFrame.width - 2 * defaultMargin, height: defaultButtonSize.y))
        slider.minimumValue = 0.25
        slider.maximumValue = 4
        slider.value = 1
        slider.center = self.center
        slider.isHidden = true
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()

    lazy var adjustsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [brightnessButton, saturationButton, contrastButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()

    lazy var brightnessSlider: UISlider = {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: margins.layoutFrame.width - 2 * defaultMargin, height: defaultButtonSize.y))
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        slider.center = self.center
        slider.isHidden = true
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()

    lazy var saturationSlider: UISlider = {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: margins.layoutFrame.width - 2 * defaultMargin, height: defaultButtonSize.y))
        slider.minimumValue = 0
        slider.maximumValue = 2
        slider.value = 1
        slider.center = self.center
        slider.isHidden = true
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()

    lazy var filtersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.cellId)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        return collectionView
    }()

    init(
        startAction: @escaping ButtonHandler,
        deleteAction: @escaping ButtonHandler,
        saveAction: @escaping (UIImage?)->()
    ) {
        self.startAction = startAction
        super.init(frame: CGRect.zero)
        self.deleteAction = deleteDecorated(with: deleteAction)
        self.saveAction = saveDecorated(with: saveAction)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
