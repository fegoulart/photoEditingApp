import Foundation

import UIKit

final class PhotoEditingView: UIView {

    typealias ButtonHandler = () -> ()
    var segmentHeight: CGFloat { 44 }
    var defaultMargin: CGFloat { 20 }
    var largeButtonSize: CGPoint { CGPoint(x: 100, y: 100) }
    var defaultButtonSize: CGPoint { CGPoint(x: 44, y: 44) }

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
        UISegmentedControl(items: ["Filters", "Adjusts"])
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

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.backgroundColor = .red
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
