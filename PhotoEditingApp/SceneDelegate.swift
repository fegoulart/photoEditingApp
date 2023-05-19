import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let imagePicker = PhotoEditingImagePicker(pickerController: UIImagePickerController())
        let startAction: PhotoEditingView.ButtonHandler = { [weak imagePicker] in
            imagePicker?.present()
        }

        let viewModel = ViewModel(cacheImageService: FileCacheImageService())
        let deleteAction: PhotoEditingView.ButtonHandler = { [weak viewModel] in
            viewModel?.clear()
        }
        let photoEditingView = PhotoEditingView(startAction: startAction, deleteAction: deleteAction)

        photoEditingView.startAction = startAction
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
