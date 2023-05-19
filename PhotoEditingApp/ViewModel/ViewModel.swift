import Foundation

final class ViewModel {

    @Published private(set) var imageData: Data?

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
}

enum CacheImageError: Error {
    case couldNotSave
    case couldNotRetrieve
}

protocol CacheImageService {
    func cache(_ image: Data) throws
    func retrieve() -> Data?
    func delete()
}

final class FileCacheImageService: CacheImageService {

    let name: String = "cachedImage.png"

    func cache(_ image: Data) throws {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            throw CacheImageError.couldNotSave
        }
        do {
            try image.write(to: directory.appendingPathComponent(name)!)
        } catch {
            throw CacheImageError.couldNotSave
        }
    }

    func retrieve() -> Data? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return try? Data(contentsOf: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name))
        }
        return nil
    }

    func delete() {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            try? FileManager.default.removeItem(at: dir.appendingPathComponent(name))
        }
    }
}
