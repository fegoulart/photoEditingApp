final class ImagePickerViewModel {

    let permissionChecker: PermissionChecker

    init(
        permissionChecker: PermissionChecker
    ) {
        self.permissionChecker = permissionChecker
    }

    func checkPermission(for permission: AppPermissions, completion: @escaping (Bool)->()) {
        permissionChecker.checkFor(permission, completion: completion)
    }
}
