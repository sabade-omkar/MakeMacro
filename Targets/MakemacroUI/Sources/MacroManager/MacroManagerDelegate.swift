import UIKit
import MakeMacroKit

protocol MacroInteractable: Scaleble, Transleatable {
    var delegate: MacroManagerDelegate? { get }

    func addGestures(to view: UIView)
}

protocol MacroManagerDelegate: AnyObject {
    func didTap()
    func didChangeScale(by scaleFactor: CGFloat)
    func didChangePosition(dx: CGFloat, dy: CGFloat)
}
