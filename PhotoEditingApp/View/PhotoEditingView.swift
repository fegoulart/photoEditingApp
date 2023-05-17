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

    lazy var segmentControl: UISegmentedControl = {
        return UISegmentedControl(items: ["Filters", "Adjusts"])

    }()

    init() {
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

    }

    func additionalSetup() {
        self.backgroundColor = .white
    }
}

