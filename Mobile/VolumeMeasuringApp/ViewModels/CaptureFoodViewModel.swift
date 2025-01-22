import Foundation
import UIKit

class CaptureFoodViewModel: ObservableObject {
    @Published var storedImage: UIImage?
    
    func captureImage(image: UIImage) {
        storedImage = image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
