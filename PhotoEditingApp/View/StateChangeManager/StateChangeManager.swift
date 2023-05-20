protocol StateChangeManager {
    typealias ClientBlock = ()->()
    func setNewState(completion: @escaping ClientBlock)
    func signal()
}
