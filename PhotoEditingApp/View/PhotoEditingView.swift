import Foundation

import UIKit

class PhotoEditingView: UIView {

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

    var startAction: UIAction?

    lazy var segmentControl: UISegmentedControl = {
        UISegmentedControl(items: ["Filters", "Adjusts"])
    }()

    lazy var startButton: UIButton = {
        let image = UIImage(systemName: "plus.circle", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 100))
        var configuration = UIButton.Configuration.borderedTinted()
        configuration.image = image
        configuration.imagePadding = 100
        configuration.imagePlacement = .all
        assert(startAction != nil)
        return UIButton(configuration: configuration, primaryAction: startAction)
    }()

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(startAction: UIAction) {
        self.startAction = startAction
        super.init(frame: CGRect.zero)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension PhotoEditingView: ViewCodeProtocol {
    func setupHierarchy() {
        addSubview(segmentControl)
        addSubview(startButton)
        addSubview(photoImageView)
    }

    func setupConstraints() {

        segmentControl.constraint { view in
            [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20),
                view.heightAnchor.constraint(equalToConstant: 40)
                ]
        }

        startButton.constraint { view in
            [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -20),
                view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20)
            ]
        }

        photoImageView.constraint { view in
            [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -20),
                view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20)
            ]
        }

    }

    func additionalSetup() {
        self.backgroundColor = .white
    }
}
