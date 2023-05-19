import Foundation
import UIKit

extension PhotoEditingView: ViewCodeProtocol {
    func setupHierarchy() {
        addSubview(segmentControl)
        addSubview(startButton)
        addSubview(photoImageView)
        addSubview(deleteButton)
    }

    func setupConstraints() {

        segmentControl.constraint { view in
            [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: defaultMargin),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -1 * defaultMargin),
                view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -1 * defaultMargin),
                view.heightAnchor.constraint(equalToConstant: segmentHeight),
            ]
        }

        segmentControl.setContentHuggingPriority(.defaultHigh, for: .vertical)

        startButton.constraint { view in
            [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: defaultMargin),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -1 * defaultMargin),
                view.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -1 * defaultMargin),
                view.topAnchor.constraint(equalTo: margins.topAnchor, constant: defaultMargin)
            ]
        }

        deleteButton.constraint { view in
            [
                view.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: defaultMargin),
                view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                view.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
                view.widthAnchor.constraint(equalToConstant: defaultButtonSize.x)
            ]
        }

    }

    func setImageConstraints(_ newHeight: CGFloat) {
        NSLayoutConstraint.deactivate(photoImageView.constraints)

        photoImageView.constraint { view in
            [
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: defaultMargin),
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -1 * defaultMargin),
                view.heightAnchor.constraint(equalToConstant: newHeight),
                view.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -1 * (defaultMargin + segmentHeight))
            ]
        }
        self.layoutIfNeeded()
    }

    func additionalSetup() {
        self.backgroundColor = .white
    }
}
