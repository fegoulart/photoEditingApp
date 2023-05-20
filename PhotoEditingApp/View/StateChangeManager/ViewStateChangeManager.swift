import Foundation

final class ViewStateChangeManager: StateChangeManager {

    private let stateChangeSemaphore: DispatchSemaphore = DispatchSemaphore(value: 1)

    func signal() {
        stateChangeSemaphore.signal()
    }

    /// completion runs on MainThread
    func setNewState(completion: @escaping StateChangeManager.ClientBlock) {
        let queue = DispatchQueue(label: "com.leapi.changeViewState", qos: .userInteractive)
        queue.async {
            self.stateChangeSemaphore.wait()
            assert(!Thread.isMainThread, "Not expected to run on main thread")
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
