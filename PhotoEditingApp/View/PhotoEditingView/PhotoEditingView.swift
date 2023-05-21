import Foundation

import UIKit
import MetalKit

final class PhotoEditingView: UIView {

    typealias ButtonHandler = () -> ()
    var segmentHeight: CGFloat { 44 }
    var defaultMargin: CGFloat { 20 }
    var largeButtonSize: CGPoint { CGPoint(x: 100, y: 100) }
    var defaultButtonSize: CGPoint { CGPoint(x: 44, y: 44) }
    var iphoneSE22Width: CGFloat { 375 }

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

    lazy var segmentControl: UISegmentedControl = {
        let filtersAction = UIAction(title: "Filters") { action in
            self.showFilters()
        }
        let adjustsAction = UIAction(title: "Adjusts") { action in
            self.showAdjusts()
        }
        return UISegmentedControl(frame: CGRect.zero, actions: [filtersAction, adjustsAction])
    }()

    lazy var startButton: UIButton = {
        let image = UIImage(systemName: "plus.circle", withConfiguration:  UIImage.SymbolConfiguration(pointSize: self.largeButtonSize.y))
        var configuration = UIButton.Configuration.borderless()
        configuration.image = image
        configuration.imagePlacement = .all
        assert(startAction != nil, "StartAction should not be nil")
        return UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.startAction?()
        })
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
        var configuration = UIButton.Configuration.borderedTinted()
        configuration.image = image
        configuration.imagePlacement = .all
        assert(deleteAction != nil, "DeleteAction should not be nil")
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.deleteAction?()
        })
        button.isHidden = true
        return button
    }()

    lazy var brightnessIcon: UIImage = {
        UIImage(named: "brightness")!
    }()

    lazy var brightnessButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: defaultButtonSize.x, height: defaultButtonSize.y)
        button.setBackgroundImage(brightnessIcon, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        return button
    }()

    lazy var saturationIcon: UIImage = {
        UIImage(named: "saturation")!
    }()

    lazy var saturationButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: defaultButtonSize.x, height: defaultButtonSize.y)
        button.setBackgroundImage(saturationIcon, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        return button
    }()

    lazy var contrastIcon: UIImage = {
        UIImage(named: "contrast")!
    }()

    lazy var contrastButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: defaultButtonSize.x, height: defaultButtonSize.y)
        button.setBackgroundImage(contrastIcon, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        return button
    }()

    lazy var adjustsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [brightnessButton, saturationButton, contrastButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()

    init(startAction: @escaping ButtonHandler, deleteAction: @escaping ButtonHandler) {
        self.startAction = startAction
        super.init(frame: CGRect.zero)
        self.deleteAction = deleteDecorated(with: deleteAction)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
