import Foundation

public protocol Scaleble: AnyObject {
    var scale: CGFloat { get set }

    func didScale(by scaleFactor: CGFloat)
}
