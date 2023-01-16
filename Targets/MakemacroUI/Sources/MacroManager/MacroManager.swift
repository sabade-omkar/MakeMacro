import UIKit

// pun intended?
class MacroManager: MacroInteractable {
    var scale: CGFloat = 1
    var center: CGPoint = .zero

    weak var delegate: MacroManagerDelegate?

    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var scaleGestureRecognizer: UIPinchGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!

    init() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        scaleGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleHandler))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
    }

    func addGestures(to view: UIView) {
        view.isUserInteractionEnabled = true

        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(scaleGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Scaleable Impl
    func didScale(by scaleFactor: CGFloat) {
        scale *= scaleFactor
        delegate?.didChangeScale(by: scaleFactor)
    }

    // MARK: - Translateable Impl
    func didMove(by dx: CGFloat, dy: CGFloat) {
        center = center.applying(CGAffineTransform(translationX: dx, y: dy))
    }
}

// MARK: - Gesture Helpers
extension MacroManager {
    @objc func tapHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTap()
    }

    @objc func scaleHandler(_ gestureRecognizer: UIPinchGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began, .changed:
            didScale(by: gestureRecognizer.scale)
            gestureRecognizer.scale = 1
        default:
            break
        }
    }

    @objc func panHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began, .changed:
            guard let targetView = gestureRecognizer.view, let superView = targetView.superview else {
                return
            }

            let translation = gestureRecognizer.translation(in: superView)
            delegate?.didChangePosition(dx: translation.x, dy: translation.y)

            gestureRecognizer.setTranslation(.zero, in: superView)
        default:
            break
        }
    }
}
