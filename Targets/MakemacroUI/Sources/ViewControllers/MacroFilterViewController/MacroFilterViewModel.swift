import UIKit

class MacroFilterViewModel {
    struct State {
        var editedMacroImage: UIImage
    }

    private let macroImage: UIImage
    private var state: State

    var didUpdateImage: ((UIImage) -> Void)? {
        didSet {
            didUpdateImage?(state.editedMacroImage)
        }
    }

    init(macroImage: UIImage) {
        self.macroImage = macroImage
        self.state = State(editedMacroImage: macroImage)
    }

    func applyBlackWhiteFilter() {
        let ciImage = macroImage.ciImage ?? CIImage(image: macroImage)

        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        guard let result = filter?.outputImage else {
            state.editedMacroImage = macroImage
            return
        }

        state.editedMacroImage = UIImage(ciImage: result, scale: 1, orientation: .up)

        didUpdateImage?(state.editedMacroImage)
    }

    func removeBlackWhiteFilter() {
        state.editedMacroImage = macroImage

        didUpdateImage?(state.editedMacroImage)
    }

    func getEditedMacroImage() -> UIImage {
        state.editedMacroImage
    }
}
