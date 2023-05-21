import AVFoundation
import Photos

struct PhotoEditingAppPermissionChecker: PermissionChecker {
    func checkFor(_ permission: AppPermissions, completion: @escaping (Bool) -> Void) {
        switch permission {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            guard status != .restricted, status != .denied else {
                completion(false)
                break
            }
            guard status == .authorized else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
                break
            }
            completion(true)
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            guard status != .restricted, status != .denied else {
                completion(false)
                break
            }
            guard status == .authorized else {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    if status == .authorized {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                break
            }
            completion(true)
        }
    }
}



