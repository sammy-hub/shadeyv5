import ImageIO
import SwiftUI

struct ImageDecoder {
    static func image(from data: Data) -> Image? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
