import UIKit
import Photos

class PHUtility {
    static func getThumbnailForLatestImage(with size: CGSize, _ completion: @escaping (UIImage?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let latestImage = fetchResult.firstObject else {
            return
        }

        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true

        imageManager.requestImage(for: latestImage, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }
}
