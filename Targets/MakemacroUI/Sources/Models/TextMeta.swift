import UIKit

struct TextMeta {
    let id: MacroIdentifier
    var text: String
    var textColor: UIColor
    var font: UIFont

    init(id: MacroIdentifier) {
        self.id = id
        self.text = ""
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 16)
    }
}
