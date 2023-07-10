import Foundation
import UIKit
#if DEBUG
import SwiftUI
#endif

extension UIView {
    func constraint(_ closure: (UIView) -> [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(closure(self))
    }
#if DEBUG
    private struct Preview: UIViewRepresentable {
        // swiftlint:disable:next nesting
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }

    func showPreview() -> some View {
        Preview(view: self)
    }
#endif

    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        assert(Thread.isMainThread)
        self.alpha = 0
        self.isHidden = false
        UIView.animate(
            withDuration: duration,
            animations: { self.alpha = 1 },
            completion: { _ in
                if let complete = onCompletion { complete() }
            }
        )
    }

    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        assert(Thread.isMainThread)
        UIView.animate(
            withDuration: duration,
            animations: { self.alpha = 0 },
            completion: { _ in
                self.isHidden = true
                if let complete = onCompletion { complete() }
            }
        )
    }
}
