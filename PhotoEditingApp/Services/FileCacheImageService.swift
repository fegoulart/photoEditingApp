import Foundation

final class FileCacheImageService: CacheImageService {

    let name: String = "cachedImage.png"

    func cache(_ image: Data) throws {
        guard let directory = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) as NSURL else {
            throw CacheImageError.couldNotSave
        }
        do {
            try image.write(to: directory.appendingPathComponent(name)!)
        } catch {
            throw CacheImageError.couldNotSave
        }
    }

    func retrieve() -> Data? {
        if let dir = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
        ) {
            return try? Data(contentsOf: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name))
        }
        return nil
    }

    func delete() {
        if let dir = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
        ) {
            try? FileManager.default.removeItem(at: dir.appendingPathComponent(name))
        }
    }
}
