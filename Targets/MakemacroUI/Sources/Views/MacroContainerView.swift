import UIKit

class MacroContainerView: UIView {
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .black
        layer.cornerRadius = 16

        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addMacro(_ macroView: UIView) {
        addSubview(macroView)
        macroView.center = center
    }

    func getMacroView(for identifier: MacroIdentifier) -> MacroBaseType? {
        for subview in subviews {
            guard let macroSubView = (subview as? MacroBaseType) else {
                continue
            }

            if macroSubView.identifier == identifier {
                return macroSubView
            }
        }

        return nil
    }
}
