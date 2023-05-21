protocol PermissionChecker {
    func checkFor(_ permission: AppPermissions, completion: @escaping (Bool) -> Void)
}
