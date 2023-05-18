import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let imagePicker = PhotoEditingImagePicker(pickerController: UIImagePickerController())
        let startAction = UIAction { (action) in
            imagePicker.present()
        }
        let photoEditingView = PhotoEditingView(startAction: startAction)

        photoEditingView.startAction = startAction
        let viewModel = ViewModel(cacheImageService: FileCacheImageService())
        let viewController = ViewController(view: photoEditingView, imagePicker: imagePicker, viewModel: viewModel)
        imagePicker.delegate = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        imagePicker.presentationController = viewController

        window = UIWindow()
        window?.windowScene = scene as? UIWindowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
