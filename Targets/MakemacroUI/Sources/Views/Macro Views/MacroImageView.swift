import UIKit

class MacroImageView: UIImageView, MacroBaseType {
    private let macroManager: MacroManager

    // unused for image view right now.
    var identifier: MacroIdentifier = -1

    var macroType: MacroViewType = .image

    init() {
        macroManager = MacroManager()
        super.init(frame: .zero)

        setupView()
    }

    private func setupView() {
        macroManager.addGestures(to: self)
        macroManager.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage) {
        self.image = image
        frame = {
            // to make things easier, let's go with a fixed max dimension. Say, 160?
            let maximumDimension: CGFloat = 160

            let aspect = image.size.width / image.size.height
            let imageViewSize: CGSize
            if aspect > 1 {
                imageViewSize = CGSize(width: maximumDimension, height: maximumDimension / aspect)
            } else {
                imageViewSize =  CGSize(width: maximumDimension * aspect, height: maximumDimension)
            }

            return CGRect(origin: .zero, size: imageViewSize)
        }()
    }
}

// MARK: - MacroManagerDelegate
extension MacroImageView: MacroManagerDelegate {
    func didTap() {
        superview?.bringSubviewToFront(self)
    }

    func didChangeScale(by scaleFactor: CGFloat) {
        transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
    }

    func didChangePosition(dx: CGFloat, dy: CGFloat) {
        transform = transform.translatedBy(x: dx, y: dy)
    }
}
