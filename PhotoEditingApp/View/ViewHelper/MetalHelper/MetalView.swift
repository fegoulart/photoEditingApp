import UIKit
import MetalKit
import CoreGraphics
import CoreImage

class MetalView: MTKView {

    var context: CIContext!
    var queue: MTLCommandQueue!
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    var image: CIImage? {
        didSet {
            guard image != nil else { return }
            drawCIImge()
        }
    }

    init() {
        let device = MTLCreateSystemDefaultDevice()
        assert(device != nil, "Cannot define metal device")
        super.init(frame: .zero, device: device)
        self.isOpaque = false
        self.device = device
        self.framebufferOnly = false
        self.isPaused = true
        self.enableSetNeedsDisplay = true
        guard let device = device else { return }
        self.context = CIContext(mtlDevice: device)
        self.queue = device.makeCommandQueue()

    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func drawCIImge() {
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
        setNeedsDisplay()
    }
}
