protocol ImagePicker {
    var delegate: ImagePickerDelegate? { get }
    func present()
}
