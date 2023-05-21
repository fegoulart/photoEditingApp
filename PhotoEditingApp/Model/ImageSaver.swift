protocol ImageSaver {
    func writeToPhotoAlbum<Image>(image: Image, completion: @escaping (Result<Void, ImageSaverError>)->Void)
}
