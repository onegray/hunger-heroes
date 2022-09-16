//
//  ImageSource.swift
//  HungerHeroes
//
//  Created by onegray on 21.08.22.
//

import Foundation
import CoreImage

protocol ImageSource: AnyObject {
    func getImage(_ handler: @escaping (CGImage?)->Void)
}

class ImageAsyncSource: ImageSource {

    var image: CGImage?
    weak var atomicImage: CGImage?
    let provideImage: ()->CGImage?
    let queue: DispatchQueue

    init(queue: DispatchQueue? = nil, imageProvider: @escaping ()->CGImage?) {
        self.queue = queue ?? DispatchQueue(label: "ImageAsyncSource.queue")
        self.provideImage = imageProvider
    }

    func getImage(_ handler: @escaping (CGImage?)->Void) {
        if let image = self.atomicImage {
            handler(image)
        } else {
            self.queue.async {
                if self.atomicImage == nil, let image = self.provideImage() {
                    self.image = image
                    self.atomicImage = image
                }
                DispatchQueue.main.async {
                    handler(self.atomicImage)
                }
            }
        }
    }
}

class ImageFileSource: ImageAsyncSource {

    init(fileUrl: URL, queue: DispatchQueue? = nil) {
        super.init(queue: queue) {
            if let imageData = try? Data(contentsOf: fileUrl),
               let imageSrc = CGImageSourceCreateWithData(imageData as CFData, nil) {
                return CGImageSourceCreateImageAtIndex(imageSrc, 0, nil)
            }
            return nil
        }
    }
}
