import CoreGraphics

public struct MacroLayerMeta {
    public let image: CGImage

    /// x is actual x / canvasSize
    /// y is actual y / canvasSize
    /// width is actual width / canvasSize
    /// height is actual height / canvasSize
    public let relativePositionInCanvas: CGRect

    public init(image: CGImage, relativePositionInCanvas: CGRect) {
        self.image = image
        self.relativePositionInCanvas = relativePositionInCanvas
    }
}
