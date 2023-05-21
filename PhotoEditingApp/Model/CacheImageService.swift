import Foundation

protocol CacheImageService {
    func cache(_ image: Data) throws
    func retrieve() -> Data?
    func delete()
}
