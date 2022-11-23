//
//  MockImageStore.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import Foundation
import XCTest


class MockImageStore: ImageStore {

    var gettingImage: ImageSource?
    var gettingExp = XCTestExpectation(description: "ImageStore getImage expectation")

    var savingImage: ImageSource?
    var didSaveExp = XCTestExpectation(description: "ImageStore saveImage expectation")

    func getImage(imageId: String) -> ImageSource? {
        defer {
            self.gettingExp.fulfill()
        }
        return self.gettingImage
    }

    func saveImage(imageId: String, data: Data, completion: ((ImageSource?)->Void)?) {
        completion?(self.savingImage)
        self.didSaveExp.fulfill()
    }
}
