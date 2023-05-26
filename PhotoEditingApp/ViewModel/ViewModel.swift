import Foundation

final class ViewModel { // Readibility

    @Published private(set) var imageData: Data?
    @Published private(set) var operationResult: String = ""

    let cacheImageService: CacheImageService

    init(cacheImageService: CacheImageService) {
        self.cacheImageService = cacheImageService
    }

    func cacheImage(_ image: Data) {
        DispatchQueue.global().async {
            try? self.cacheImageService.cache(image)
        }
    }

    func retrieveImage() {
        DispatchQueue.global().async {
            self.imageData = self.cacheImageService.retrieve()
        }
    }

    func clear() {
        DispatchQueue.global().async {
            self.imageData = nil
            self.cacheImageService.delete()
        }
    }

    func setOperationResult(_ result: String) {
        operationResult = result
    }
}
