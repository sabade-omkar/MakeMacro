import Foundation
import CoreText

public class TextToImageUtility {
    public static func makeCGImage(attributedText: NSAttributedString, size: CGSize, scale: CGFloat) -> CGImage? {
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText)
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributedText.length), path, nil)

        let width = Int(size.width * scale)
        let height = Int(size.height * scale)
        let bitsPerComponent = 8
        let bytesPerRow = width * bitsPerComponent * 4
        let space = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: space,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }

        context.scaleBy(x: scale, y: scale)
        context.textMatrix = .identity

        CTFrameDraw(frame, context)

        return context.makeImage()
    }

}
