import UIKit
import MetalKit
import CoreGraphics
import CoreImage

class MetalView: MTKView {

    var context: CIContext! // should use optional
    var queue: MTLCommandQueue!
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    var image: CIImage? {
        didSet {
            guard image != nil else { return }
            draw()
        }
    }

    var toUIImage: UIImage? {
        guard let image = image, let cgImg = context.createCGImage(image, from: image.extent) else { return nil }
        return UIImage(cgImage: cgImg)
    }

    init() {
        let device = MTLCreateSystemDefaultDevice()
        assert(device != nil, "Cannot define metal device")
        super.init(frame: , device: device)
        //super.init(frame:  CGRectMake(0, 0, 100, 100), device: device)
        self.isOpaque = false
        self.device = device
        self.framebufferOnly = false
        self.isPaused = true
        self.enableSetNeedsDisplay = true
        guard let device = device else { return }
        self.context = CIContext(mtlDevice: device)
        self.queue = device.makeCommandQueue()
        self.delegate = self
        self.contentMode = .scaleAspectFit
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MetalView: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        assert(Thread.isMainThread)
        guard let image = image else { return }
        guard let drawable = currentDrawable else {
            assertionFailure("CurrentDrawable should exist")
            return
        }
        let buffer = queue.makeCommandBuffer()
        let widthScale = drawableSize.width / image.extent.width
        let heightScale = drawableSize.height / image.extent.height

        let scale = min(widthScale, heightScale)

        let scaledImage = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        let yPos = drawableSize.height / 2 - scaledImage.extent.height / 2

        let bounds = CGRect(x: 0, y: -yPos, width: drawableSize.width, height: drawableSize.height)

        context.render(scaledImage,
                       to: drawable.texture,
                       commandBuffer: buffer,
                       bounds: bounds,
                       colorSpace: colorSpace)

        buffer?.present(drawable)
        buffer?.commit()
    }
}
