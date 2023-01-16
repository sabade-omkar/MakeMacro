import UIKit

protocol MacroToolbarDelegate: AnyObject {
    func didTapText()
    func didTapImagePicker()
}

class MacroToolbar: UIStackView {
    private let addImageButton = MacroToolbar.makeDefaultButton()
    private let addTextButton = MacroToolbar.makeDefaultButton()

    weak var delegate: MacroToolbarDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        distribution = .fillEqually
        spacing = 32

        addArrangedSubview(addTextButton)
        addArrangedSubview(addImageButton)

        setupAddTextButton()
        setupAddImageButton()
    }

    static func makeDefaultButton() -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = Metric.buttonCornerRadius
        button.layer.borderWidth = Metric.buttonBorderWidth
        button.layer.borderColor = Metric.buttonBorderColor.cgColor

        button.snp.makeConstraints { make in
            make.width.equalTo(Metric.addImageButtonSize.width)
        }

        return button
    }

    struct Metric {
        static let buttonCornerRadius: CGFloat = 8
        static let buttonBorderWidth: CGFloat = 2
        static let buttonBorderColor: UIColor = UIColor.white
        static let addImageButtonSize: CGSize = CGSize(width: 48, height: 48)
    }

    enum Tools: Int {
        case text
        case imagePicker
    }
}

// MARK: - View Helpers
extension MacroToolbar {
    private func setupAddImageButton() {
        PHUtility.getThumbnailForLatestImage(with: Metric.addImageButtonSize) { [weak self] image in
            self?.addImageButton.setImage(image, for: .normal)
        }

        addImageButton.tag = Tools.imagePicker.rawValue
        addImageButton.addTarget(self, action: #selector(toolTapHandler), for: .touchUpInside)
    }

    private func setupAddTextButton() {
        addImageButton.tag = Tools.text.rawValue
        addTextButton.setImage(MakemacroUIAsset.icAddText.image, for: .normal)
        addTextButton.addTarget(self, action: #selector(toolTapHandler), for: .touchUpInside)
    }

    @objc func toolTapHandler(_ sender: UIButton) {
        guard let tool = Tools(rawValue: sender.tag) else {
            return
        }

        switch tool {
        case .text:
            delegate?.didTapText()
        case .imagePicker:
            delegate?.didTapImagePicker()
        }
    }
}
