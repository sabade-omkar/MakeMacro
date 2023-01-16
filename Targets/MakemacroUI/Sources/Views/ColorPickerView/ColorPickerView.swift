import UIKit
import SnapKit

protocol ColorPickerDelegate: AnyObject {
    func didClearBackgroundColor()
    func didSelect(_ color: UIColor)
}

class ColorPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    enum ColorPickerItem {
        case clear
        case color(UIColor)
        case otherColors
    }

    static let defaultColors: [UIColor] = [
        .white,
        .black,
        .red,
        .orange,
        .purple,
        .blue,
        .brown,
        .cyan,
        .darkGray,
        .magenta
    ]

    private let items: [ColorPickerItem]
    weak var delegate: ColorPickerDelegate?

    private let colorPickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Metric.itemSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ColorPickerCollectionViewCell.self, forCellWithReuseIdentifier: "ColorPickerCollectionViewCell")

        return collectionView
    }()

    init(_ items: [ColorPickerItem]) {
        self.items = items

        super.init(frame: .zero)
        setupViews()
    }

    convenience init(addClearColor: Bool = true, addOtherColors: Bool = true) {
        var defaultColorItems: [ColorPickerItem] = ColorPickerView.defaultColors.map {
            .color($0)
        }
        if addClearColor {
            defaultColorItems.insert(.clear, at: 0)
        }
        if addOtherColors {
            defaultColorItems.append(.otherColors)
        }

        self.init(defaultColorItems)
    }

    private func setupViews() {
        backgroundColor = .black.withAlphaComponent(0.5)
        layer.cornerRadius = 16
        addSubview(colorPickerCollectionView)

        colorPickerCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        colorPickerCollectionView.delegate = self
        colorPickerCollectionView.dataSource = self
        colorPickerCollectionView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCollectionViewCell", for: indexPath)
        (cell as? ColorPickerCollectionViewCell)?.bind(item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case .clear:
            delegate?.didClearBackgroundColor()
        case .color(let color):
            delegate?.didSelect(color)
        case .otherColors:
            // todo: launch color picker
            break
        }
    }

    struct Metric {
        static let itemSize: CGSize = CGSize(width: 32, height: 32)
    }
}
