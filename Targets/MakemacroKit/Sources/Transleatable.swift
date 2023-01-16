import Foundation

public protocol Transleatable: AnyObject {
    var center: CGPoint { get set }

    func didMove(by dx: CGFloat, dy: CGFloat)
}
