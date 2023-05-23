import UIKit

final class FilterCell: UICollectionViewCell {

    static let cellId = "MyCustomCell"

    private var imageView: MetalView?
    var image: CIImage?

    func configure(image: CIImage?, with filter: PhotoEditingFilter) {

        self.contentView.layer.cornerRadius = 4
        self.contentView.backgroundColor = .clear
        self.image = image
        if let image = image {
            let filter = CIFilter(name: filter.rawValue)
            filter?.setValue(image, forKey: kCIInputImageKey)
            guard let filteredImage = filter?.outputImage else { return }
            if imageView == nil {
                imageView = MetalView()
            }
            self.contentView.addSubview(imageView!)
            imageView!.constraint { view in
                [
                    view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                    view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                    view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
                ]
            }
            imageView!.image = filteredImage
            assert(filter != nil, "Filter should not be null")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.removeFromSuperview()
    }
}


