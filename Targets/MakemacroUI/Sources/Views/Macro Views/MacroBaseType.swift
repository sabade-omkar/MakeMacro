import UIKit

typealias MacroIdentifier = Int

enum MacroViewType {
    case label
    case image
}

protocol MacroBaseType {
    var identifier: MacroIdentifier { get }

    var macroType: MacroViewType { get }
}
