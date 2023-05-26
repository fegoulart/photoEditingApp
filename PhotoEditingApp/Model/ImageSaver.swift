
protocol ImageSaver {

    /// <#Description#>
    /// - Parameters:
    ///   - image:
    ///   - completion: 
    func writeToPhotoAlbum<Image>(image: Image, completion: @escaping (Result<Void, ImageSaverError>)->Void)
}
