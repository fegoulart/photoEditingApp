import UIKit

final class PhotoAlbumSaver: NSObject, ImageSaver {
    typealias Image = UIImage

    var completion: ((Result<Void, ImageSaverError>) -> Void)?

    func writeToPhotoAlbum<Image>(image: Image, completion: @escaping (Result<Void, ImageSaverError>) -> Void) {
        guard let currentImage: UIImage = image as? UIImage else { completion(.failure(.invalidImage)); return }
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            completion?(.failure(.errorSavingImage))
            return
        }
        completion?(.success(()))
    }
}
