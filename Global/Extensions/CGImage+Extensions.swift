//
// Created by onegray on 1.09.22.
//

import CoreGraphics

extension CGImage {

    static func blankAlphaOnlyImage(width: Int, height: Int) -> CGImage {
        let colorspace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: width, height: height,
                bitsPerComponent: 8, bytesPerRow: 0, space: colorspace,
                bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue)!
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        return context.makeImage()!
    }
}
