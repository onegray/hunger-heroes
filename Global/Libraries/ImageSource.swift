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


class ImageFileSource: ImageSource {

    let fileUrl: URL
    let queue: DispatchQueue
    var image: CGImage?
    weak var atomicImage: CGImage?

    init(fileUrl: URL, queue: DispatchQueue? = nil) {
        self.fileUrl = fileUrl
        self.queue = queue ?? DispatchQueue(label: "ImageFileSource.queue")
    }

    func getImage(_ handler: @escaping (CGImage?)->Void) {

        if let img = self.atomicImage {
            handler(img)
        } else {
            self.queue.async {
                if self.atomicImage == nil {
                    if let imageData = try? Data(contentsOf: self.fileUrl),
                       let imageSrc = CGImageSourceCreateWithData(imageData as CFData, nil) {
                        self.image = CGImageSourceCreateImageAtIndex(imageSrc, 0, nil)
                        self.atomicImage = self.image
                    }
                }

                DispatchQueue.main.async {
                    handler(self.atomicImage)
                }
            }
        }
    }
}
