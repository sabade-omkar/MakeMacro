import CoreGraphics
import Foundation
import MakeMacroKit
import CoreImage

public class MacroMakerViewModel {
    struct State {
        var textMeta: [MacroIdentifier: TextMeta] = [:]
        var image: [MacroIdentifier: ImageMeta] = [:]
    }

    private var state: State

    public init() {
        state = State()
    }

    func getTextMeta(forId id: MacroIdentifier) -> TextMeta? {
        state.textMeta[id]
    }

    func upsert(_ textMeta: TextMeta) -> UpsertResult {
        let upsertResult: UpsertResult = state.textMeta.keys.contains(textMeta.id) ? .updated : .inserted
        state.textMeta[textMeta.id] = textMeta

        return upsertResult
    }

    func getRelativePositionInCanvas(viewRect: CGRect, canvasSize: CGSize) -> CGRect {
        let relativeX = viewRect.minX / canvasSize.width
        let relativeY = viewRect.minY / canvasSize.height

        let relativeWidth = viewRect.size.width / canvasSize.width
        let relativeHeight = viewRect.size.height / canvasSize.height

        return CGRect(x: relativeX, y: relativeY, width: relativeWidth, height: relativeHeight)
    }

    func exportMacro(
        withLayers macroViewMeta: [MacroLayerMeta],
        canvasSize: CGSize,
        canvasColor: CGColor
    ) -> CIImage {
        MacroExporterUtility.export(
            canvasMeta: MacroCanvasMeta(canvasSize: canvasSize, canvasColor: canvasColor, macroLayers: macroViewMeta)
        )
    }

    func getNextIdentifierForText() -> MacroIdentifier {
        // probably just use a UUID
        (state.textMeta.keys.max() ?? 0) + 1
    }
}
