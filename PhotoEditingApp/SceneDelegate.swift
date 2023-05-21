import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let permissionChecker = PhotoEditingAppPermissionChecker()
        let imagePickerViewModel = ImagePickerViewModel(permissionChecker: permissionChecker)
        let imagePicker = PhotoEditingImagePicker(pickerController: UIImagePickerController(), viewModel: imagePickerViewModel)
        let startAction: PhotoEditingView.ButtonHandler = { [weak imagePicker] in
            imagePicker?.present()
        }

        let viewModel = ViewModel(cacheImageService: FileCacheImageService())
        let deleteAction: PhotoEditingView.ButtonHandler = { [weak viewModel] in
            viewModel?.clear()
        }

        let imageSaver = PhotoAlbumSaver()
        let saveAction: (UIImage?) -> Void = { [weak viewModel] image in
            imageSaver.writeToPhotoAlbum(image: image) { result in
                switch result {
                case .success:
                    viewModel?.setOperationResult("Image successfully saved")
                    viewModel?.clear()
                case .failure:
                    viewModel?.setOperationResult("Error: please try again later")
                }
            }
        }
        let photoEditingView = PhotoEditingView(startAction: startAction, deleteAction: deleteAction, saveAction: saveAction)

        photoEditingView.startAction = startAction
        let viewController = ViewController(view: photoEditingView, imagePicker: imagePicker, viewModel: viewModel, stateChangeManager: ViewStateChangeManager())
        imagePicker.delegate = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        imagePicker.presentationController = viewController

        window = UIWindow()
        window?.windowScene = scene as? UIWindowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
