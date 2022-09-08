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

    func imageClearLines(_ lines: [PolyLine]) -> CGImage {
        let colorspace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: self.width, height: self.height,
                bitsPerComponent: 8, bytesPerRow: 0, space: colorspace,
                bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue)!

        context.draw(self, in: CGRect(x: 0, y: 0, width: self.width, height: self.height))

        context.setBlendMode(.clear)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(CGColor(gray: 0, alpha: 1.0))
        context.setShadow(offset: .zero, blur: 2.0)

        for line in lines {
            if line.points.count > 0 {
                context.setLineWidth(CGFloat(line.width))
                context.move(to: line.points[0].cgPoint)
                for p in line.points {
                    context.addLine(to: p.cgPoint)
                }
                context.strokePath()
            }
        }
        return context.makeImage()!
    }
}
