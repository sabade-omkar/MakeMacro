import UIKit

protocol MacroLabelDelegate: AnyObject {
    func didTap(with textId: MacroIdentifier)
}

class MacroLabel: UILabel, MacroBaseType {
    private let macroManager: MacroManager

    var identifier: MacroIdentifier = -1

    var macroType: MacroViewType = .label

    weak var delegate: MacroLabelDelegate?

    init() {
        macroManager = MacroManager()
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        macroManager.addGestures(to: self)
        macroManager.delegate = self
    }

    func bind(_ textMeta: TextMeta) {
        identifier = textMeta.id

        font = textMeta.font
        textColor = textMeta.textColor
        text = textMeta.text

        sizeToFit()
    }
}

// MARK: - MacroManagerDelegate
extension MacroLabel: MacroManagerDelegate {
    func didTap() {
        superview?.bringSubviewToFront(self)
        delegate?.didTap(with: identifier)
    }

    func didChangeScale(by scaleFactor: CGFloat) {
        transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
    }

    func didChangePosition(dx: CGFloat, dy: CGFloat) {
        transform = transform.translatedBy(x: dx, y: dy)
    }
}
