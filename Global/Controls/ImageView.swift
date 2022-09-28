//
// Created by onegray on 24.09.22.
//

import UIKit
import SwiftUI

struct ImageView: UIViewRepresentable {

    let imageSource: ImageSource?
    var contentMode: ContentMode = .fit

    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        let imageView = UIImageView(frame: uiView.bounds)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = self.contentMode == .fit ? .scaleAspectFit : .scaleAspectFill
        uiView.addSubview(imageView)
        return uiView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let imageView = uiView.subviews.first as? UIImageView {
            self.imageSource?.getImage { cgImage in
                imageView.image = cgImage != nil ? UIImage(cgImage: cgImage!) : nil
            }
            imageView.contentMode = self.contentMode == .fit ? .scaleAspectFit : .scaleAspectFill
        }
    }
}

extension ImageView {
    func aspectRatio(contentMode: ContentMode) -> ImageView {
        var view = self
        view.contentMode = contentMode
        return view
    }
}
