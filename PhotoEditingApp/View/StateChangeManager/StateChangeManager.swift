protocol StateChangeManager {
    typealias ClientBlock = () -> Void
    func setNewState(completion: @escaping ClientBlock)
    func signal()
}
