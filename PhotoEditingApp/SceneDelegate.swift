import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        let navigationController = UINavigationController(rootViewController: PhotoEditingComposer.makeViewController())

        window = UIWindow()
        window?.windowScene = scene as? UIWindowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
