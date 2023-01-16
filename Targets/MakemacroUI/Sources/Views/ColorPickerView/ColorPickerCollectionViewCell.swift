import UIKit

class ColorPickerCollectionViewCell: UICollectionViewCell {
    private let itemIndicatorImageView = UIImageView()

    override var isSelected: Bool {
        didSet {
            itemIndicatorImageView.layer.borderWidth = isSelected ? Metric.selectedBorderWidth : Metric.defaultBorderWidth
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        itemIndicatorImageView.layer.cornerRadius = layer.frame.width / 2
    }

    private func setupUI() {
        contentView.addSubview(itemIndicatorImageView)

        itemIndicatorImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        itemIndicatorImageView.layer.borderColor = Metric.borderColor.cgColor
        itemIndicatorImageView.layer.borderWidth = Metric.defaultBorderWidth
    }

    func bind(_ item: ColorPickerView.ColorPickerItem) {
        switch item {
        case .clear:
            itemIndicatorImageView.backgroundColor = nil
        case .color(let uiColor):
            itemIndicatorImageView.backgroundColor = uiColor
        case .otherColors:
            // todo: add some icon here
            itemIndicatorImageView.image = nil
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        itemIndicatorImageView.backgroundColor = nil
        itemIndicatorImageView.image = nil
    }

    struct Metric {
        static let selectedBorderWidth: CGFloat = 3
        static let defaultBorderWidth: CGFloat = 1
        static let borderColor: UIColor = .white
    }
}
