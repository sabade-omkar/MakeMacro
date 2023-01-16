import UIKit

protocol TextMacroDelegate: AnyObject {
    func didDismiss(with textMeta: TextMeta)
}

class TextMacroViewController: UIViewController {
    private var textMeta: TextMeta

    private let textPreviewView = UIView()
    private let inputTextView = UITextView()
    private let colorPickerView = ColorPickerView(addClearColor: false, addOtherColors: true)

    weak var delegate: TextMacroDelegate?

    init(textMeta: TextMeta) {
        self.textMeta = textMeta

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextPreviewView()
        setupTextView()
        setupColorPicker()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    struct Metric {
        static let colorPickerHeight: CGFloat = 32 + 16
    }
}

// MARK: - Delegates
extension TextMacroViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension TextMacroViewController: ColorPickerDelegate {
    func didClearBackgroundColor() {
        // unused
    }

    func didSelect(_ color: UIColor) {
        inputTextView.textColor = color
    }
}

// MARK: - View Helpers
extension TextMacroViewController {
    private func setupTextPreviewView() {
        textPreviewView.frame = view.bounds
        textPreviewView.backgroundColor = .black.withAlphaComponent(0.6)
        textPreviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textPreviewTapHandler)))

        view.addSubview(textPreviewView)
    }

    private func setupTextView() {
        textPreviewView.addSubview(inputTextView)
        inputTextView.isScrollEnabled = false
        inputTextView.delegate = self
        inputTextView.font = UIFont.systemFont(ofSize: 16)
        inputTextView.backgroundColor = .clear
        inputTextView.snp.makeConstraints { make in
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (navigationController?.navigationBar.frame.height ?? 0.0)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(topBarHeight)
            make.leading.trailing.equalToSuperview().inset(32)
        }

        inputTextView.becomeFirstResponder()

        initialiseTextViewWithMeta()
    }

    private func initialiseTextViewWithMeta() {
        inputTextView.text = textMeta.text
        inputTextView.font = textMeta.font
        inputTextView.textColor = textMeta.textColor
    }

    private func setupColorPicker() {
        view.addSubview(colorPickerView)
        colorPickerView.delegate = self

        colorPickerView.frame = CGRect(
            x: 8,
            y: view.frame.maxY,
            width: view.frame.width,
            height: Metric.colorPickerHeight
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        textPreviewView.frame.size.height = keyboardRect.minY
        colorPickerView.frame = CGRect(
            x: 8,
            y: keyboardRect.minY - 8 - Metric.colorPickerHeight, // 16 padding, and height
            width: keyboardRect.width - 8 * 2,
            height: Metric.colorPickerHeight
        )
    }

    @objc func keyboardWillHide(notification: Notification) {
        textPreviewView.frame.origin.y = view.frame.height
    }

    @objc func textPreviewTapHandler(_ sender: Any?) {
        textMeta.text = inputTextView.text
        textMeta.font = inputTextView.font ?? textMeta.font
        textMeta.textColor = inputTextView.textColor ?? textMeta.textColor

        delegate?.didDismiss(with: textMeta)

        dismiss(animated: true)
    }
}
