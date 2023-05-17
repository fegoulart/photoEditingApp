import UIKit

final class ViewController: UIViewController {

    private(set) var photoEditingView: UIView

    override func viewDidLoad() {
        self.view = photoEditingView
        super.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(view: UIView) {
        self.photoEditingView = view
        super.init(nibName: nil, bundle: nil)
    }

}

