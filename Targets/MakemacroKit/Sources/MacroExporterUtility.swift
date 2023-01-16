import CoreGraphics
import CoreImage
import CoreImage.CIFilterBuiltins

public struct MacroCanvasMeta {
    let canvasSize: CGSize
    let canvasColor: CGColor

    let macroLayers: [MacroLayerMeta]

    public init(canvasSize: CGSize, canvasColor: CGColor, macroLayers: [MacroLayerMeta]) {
        self.canvasSize = canvasSize
        self.canvasColor = canvasColor
        self.macroLayers = macroLayers
    }
}


public class MacroExporterUtility {
    public static func export(canvasMeta: MacroCanvasMeta) -> CIImage {
        var canvasImage = CIImage(color: CIColor(cgColor: canvasMeta.canvasColor))
            .cropped(to: CGRect(origin: .zero, size: canvasMeta.canvasSize))

        for layer in canvasMeta.macroLayers {
            canvasImage = composite(layer: layer, over: canvasImage)
        }

        return canvasImage
    }

    private static func composite(layer: MacroLayerMeta, over backgroundImage: CIImage) -> CIImage {
        let backgroundImageSize = backgroundImage.extent.size

        let currentHeight = CGFloat(layer.image.height)
        let actualHeight = layer.relativePositionInCanvas.height * backgroundImageSize.height
        let scale = actualHeight / currentHeight

        let actualX = (layer.relativePositionInCanvas.origin.x) * backgroundImageSize.width
        let actualY = (1 - layer.relativePositionInCanvas.origin.y) * backgroundImageSize.height - actualHeight

        let layerCIImage = CIImage(cgImage: layer.image).transformed(
            by: CGAffineTransform(scaleX: scale, y: scale)
        )
        let layerCIImageTranslated = layerCIImage.transformed(by: CGAffineTransform(translationX: actualX, y: actualY))

        return layerCIImageTranslated.composited(over: backgroundImage)
    }
}
