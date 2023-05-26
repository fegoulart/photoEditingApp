import XCTest
@testable import PhotoEditingApp

final class PhotoEditingAppTests: XCTestCase {

    func testComposerMemoryLeak() throws {
        _ = makeSUT()
    }

    // MARK: - Helpers

    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ViewController? {
        let permissionChecker = PhotoEditingAppPermissionChecker()

        let imagePickerViewModel = ImagePickerViewModel(permissionChecker: permissionChecker)
        trackForMemoryLeaks(imagePickerViewModel, file: file, line: line)
        let imagePicker = PhotoEditingImagePicker(pickerController: UIImagePickerController(), pickerViewModel: imagePickerViewModel)
        trackForMemoryLeaks(imagePicker, file: file, line: line)
        let startAction: PhotoEditingView.ButtonHandler = { [weak imagePicker] in
            imagePicker?.present()
        }
 
        let viewModel = ViewModel(cacheImageService: FileCacheImageService())
        trackForMemoryLeaks(viewModel, file: file, line: line)
        let deleteAction: PhotoEditingView.ButtonHandler = { [weak viewModel] in
            viewModel?.clear()
        }
        let imageSaver = PhotoAlbumSaver()
        let saveAction: (UIImage?) -> Void = { [weak viewModel] image in
            imageSaver.writeToPhotoAlbum(image: image) { result in
                switch result {
                case .success:
                    viewModel?.setOperationResult("Image successfully saved")
                    viewModel?.clear()
                case .failure:
                    viewModel?.setOperationResult("Error: please try again later")
                }
            }
        }
        trackForMemoryLeaks(imageSaver, file: file, line: line)
        let photoEditingView = PhotoEditingView(startAction: startAction, deleteAction: deleteAction, saveAction: saveAction)

        photoEditingView.startAction = startAction
        trackForMemoryLeaks(photoEditingView, file: file, line: line)
        let viewController = ViewController(view: photoEditingView, imagePicker: imagePicker, viewModel: viewModel, stateChangeManager: ViewStateChangeManager())
        imagePicker.delegate = viewController
        imagePicker.presentationController = viewController
        trackForMemoryLeaks(viewController, file: file, line: line)
        return viewController
    }

}
