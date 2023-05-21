protocol ImagePickerDelegate: AnyObject {
    func didSelect<Image>(_ image: Image?)
}
