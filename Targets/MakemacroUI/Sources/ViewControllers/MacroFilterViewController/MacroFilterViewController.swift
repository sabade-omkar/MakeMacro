import UIKit
import MakeMacroKit

class MacroFilterViewController: UIViewController {
    typealias ViewModel = MacroFilterViewModel
    private let viewModel: ViewModel

    private let imagePreview = UIImageView()

    private let applyFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "Apply B/W filter?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white

        return label
    }()

    private let applyFilterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        filterSwitch.isOn = false

        return filterSwitch
    }()

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()

        bindViewModel()
    }

    private func setupViews() {
        view.backgroundColor = .gray

        setupImagePreview()
        setupFilterSwitch()
    }
}

// MARK: - ViewModel
extension MacroFilterViewController {
    private func bindViewModel() {
        viewModel.didUpdateImage = { [weak self] updatedImage in
            self?.imagePreview.image = updatedImage
        }
    }
}

// MARK: - UI Helpers
extension MacroFilterViewController {
    private func setupImagePreview() {
        view.addSubview(imagePreview)
        imagePreview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(imagePreview.snp.width)
        }

        imagePreview.layer.cornerRadius = 16
        imagePreview.clipsToBounds = true
    }

    private func setupFilterSwitch() {
        view.addSubview(applyFilterLabel)
        view.addSubview(applyFilterSwitch)

        applyFilterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(applyFilterSwitch)
            make.leading.equalToSuperview().inset(16)
        }

        applyFilterSwitch.snp.makeConstraints { make in
            make.top.equalTo(imagePreview.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        applyFilterSwitch.addTarget(self, action: #selector(filterSwitchValueChangedHandler), for: .valueChanged)
    }

    @objc func filterSwitchValueChangedHandler() {
        if applyFilterSwitch.isOn {
            viewModel.applyBlackWhiteFilter()
        } else {
            viewModel.removeBlackWhiteFilter()
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = "Macro Filters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Export", style: .plain, target: self, action: #selector(exportTapped)
        )
    }

    @objc func exportTapped() {
        let editedImage = viewModel.getEditedMacroImage()

        let activityViewController = UIActivityViewController(activityItems: [editedImage] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view

        present(activityViewController, animated: true, completion: nil)
    }
}
