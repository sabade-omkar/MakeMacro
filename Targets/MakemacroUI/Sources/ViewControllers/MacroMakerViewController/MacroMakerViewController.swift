import UIKit
import SnapKit
import MakeMacroKit

public class MacroMakerViewController: UIViewController {
    public typealias ViewModel = MacroMakerViewModel
    private let viewModel: ViewModel

    private let containerView = MacroContainerView()

    private let colorPickerTitleLabel = {
        let label = UILabel()
        label.text = "Pick background color"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white

        return label
    }()
    private let colorPickerView = ColorPickerView()

    private let macroToolbar = MacroToolbar()
    
    public init(viewModel: ViewModel = ViewModel()) {
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
    }

    private func setupViews() {
        setupContainerView()
        setupColorPicker()
        setupAddMacroButton()
    }

    struct Metric {
        static let colorPickerHeight: CGFloat = 32 + 16
        static let macroToolBarHeight: CGFloat = 48
    }
}

// MARK: - Delegates
extension MacroMakerViewController: ColorPickerDelegate {
    func didClearBackgroundColor() {
        containerView.backgroundColor = .clear
    }

    func didSelect(_ color: UIColor) {
        containerView.backgroundColor = color
    }
}

extension MacroMakerViewController: MacroToolbarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didTapText() {
        colorPickerView.isHidden = true

        let textMacroViewController = TextMacroViewController(textMeta: .init(id: viewModel.getNextIdentifierForText()))
        textMacroViewController.modalPresentationStyle = .overCurrentContext
        textMacroViewController.modalTransitionStyle = .crossDissolve
        textMacroViewController.delegate = self

        present(textMacroViewController, animated: true)
    }

    func didTapImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self

        present(pickerController, animated: true)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) else {
            return
        }

        addImageMacro(selectedImage)
        dismiss(animated: true)
    }

    private func addImageMacro(_ image: UIImage) {
        let macroImageView = MacroImageView()
        macroImageView.setImage(image)

        containerView.addMacro(macroImageView)
    }
}

extension MacroMakerViewController: MacroLabelDelegate {
    func didTap(with textId: MacroIdentifier) {
        guard let textMeta = viewModel.getTextMeta(forId: textId),
              let macroLabel = containerView.getMacroView(for: textMeta.id) as? MacroLabel else {
            return
        }

        // hiding the label while it is being edited.
        macroLabel.isHidden = true

        // hiding the colorpickerview for macro background as it may overlap with text editor's
        // color picker view
        colorPickerView.isHidden = true

        let textMacroViewController = TextMacroViewController(textMeta: textMeta)
        textMacroViewController.modalPresentationStyle = .overCurrentContext
        textMacroViewController.modalTransitionStyle = .crossDissolve
        textMacroViewController.delegate = self

        present(textMacroViewController, animated: true)
    }
}

extension MacroMakerViewController: TextMacroDelegate {
    func didDismiss(with textMeta: TextMeta) {
        colorPickerView.isHidden = false

        let upsertResult = viewModel.upsert(textMeta)
        switch upsertResult {
        case .inserted:
            let macroLabel = MacroLabel()
            macroLabel.bind(textMeta)
            macroLabel.delegate = self

            containerView.addMacro(macroLabel)
        case .updated:
            guard let macroLabel = containerView.getMacroView(for: textMeta.id) as? MacroLabel else {
                break
            }

            macroLabel.bind(textMeta)
            macroLabel.isHidden = false
        }
    }
}

// MARK: - UI Helpers
extension MacroMakerViewController {
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(containerView.snp.width)
        }
    }

    private func setupColorPicker() {
        view.addSubview(colorPickerView)
        view.addSubview(colorPickerTitleLabel)
        colorPickerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        colorPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(Metric.colorPickerHeight)
            make.top.equalTo(colorPickerTitleLabel.snp.bottom).offset(16)
        }

        colorPickerView.delegate = self
    }

    private func setupAddMacroButton() {
        view.addSubview(macroToolbar)

        macroToolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(Metric.macroToolBarHeight)
        }
        macroToolbar.delegate = self
    }

    private func setupNavigationBar() {
        navigationItem.title = "Macro Maker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next", style: .plain, target: self, action: #selector(exportTapped)
        )
    }

    @objc func exportTapped() {
        var macroLayers: [MacroLayerMeta] = []

        for macroView in containerView.subviews {
            guard let macroView = macroView as? MacroBaseType else {
                return
            }

            var macroCGImage: CGImage? = nil
            var macroFrame: CGRect? = nil

            switch macroView.macroType {
            case .label:
                guard let macroLabel = macroView as? MacroLabel,
                      let textMeta = viewModel.getTextMeta(forId: macroLabel.identifier) else {
                    break
                }

                let attributedString = NSAttributedString(
                    string: textMeta.text, attributes: [
                        .font: textMeta.font, .foregroundColor: textMeta.textColor, .backgroundColor: UIColor.clear
                    ]
                )
                guard let textImage = TextToImageUtility.makeCGImage(
                    attributedText: attributedString,
                    size: macroLabel.frame.size,
                    scale: UIScreen.main.scale
                ) else {
                    #if DEBUG
                    print("error: Couldn't convert textMeta to CGImage")
                    #endif
                    break
                }

                macroCGImage = textImage
                macroFrame = macroLabel.frame
            case .image:
                guard let macroImageView = macroView as? MacroImageView,
                      let image = macroImageView.image else { // ideally you would read from the file. Skipping that for this POC.
                    #if DEBUG
                    print("error: Couldn't find image in macroImageView")
                    #endif
                    break
                }

                guard var ciImage = CIImage(image: image) else {
                    #if DEBUG
                    print("error: Couldn't convert uiimage to cgimage")
                    #endif
                    break
                }

                var rotationAngle: CGFloat = 0
                let imageOrientation = image.imageOrientation
                if imageOrientation != .up {
                    switch imageOrientation {
                    case .up, .upMirrored:
                        rotationAngle = 0
                    case .down, .downMirrored:
                        rotationAngle = -180
                    case .left, .leftMirrored:
                        rotationAngle = 90
                    case .right, .rightMirrored:
                        rotationAngle = -90
                    @unknown default:
                        rotationAngle = 0
                    }

                    let radians = ImageOpsUtility.toRadians(rotationAngle)
                    ciImage = ciImage.transformed(by: CGAffineTransform(rotationAngle: radians))
                }

                let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent)

                macroCGImage = cgImage
                macroFrame = macroImageView.frame
            }

            guard let macroFrame = macroFrame, let macroCGImage = macroCGImage else {
                continue
            }

            let relativePositionInCanvas = viewModel.getRelativePositionInCanvas(
                viewRect: macroFrame, canvasSize: containerView.frame.size
            )
            macroLayers.append(
                MacroLayerMeta(image: macroCGImage, relativePositionInCanvas: relativePositionInCanvas)
            )
        }

        let macroCIImage = viewModel.exportMacro(
            withLayers: macroLayers,
            canvasSize: MacroKitConstants.renderSize,
            canvasColor: (containerView.backgroundColor ?? UIColor.black).cgColor
        )
        let macroUIImage = UIImage(ciImage: macroCIImage, scale: 1, orientation: .up)

        let macroFilterViewModel = MacroFilterViewController.ViewModel(macroImage: macroUIImage)
        let macroFilterViewController = MacroFilterViewController(viewModel: macroFilterViewModel)

        navigationController?.pushViewController(macroFilterViewController, animated: true)
    }
}
