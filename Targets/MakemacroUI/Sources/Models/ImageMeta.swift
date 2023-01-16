import UIKit

struct ImageMeta {
    let id: Int
    let originalImage: UIImage

    init(id: Int, originalImage: UIImage) {
        self.id = id
        self.originalImage = originalImage
    }
}
