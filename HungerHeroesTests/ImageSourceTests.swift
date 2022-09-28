//
//  ImageSourceTests.swift
//  HungerHeroesTests
//
//  Created by onegray on 28.09.22.
//

import XCTest
@testable import HungerHeroes

class ImageSourceTests: XCTestCase {

    var testImage: CGImage!
    var queue: DispatchQueue!

    override func setUp() {
        super.setUp()
        self.testImage = UIImage(systemName: "circle")!.cgImage
        self.queue = DispatchQueue(label: "serial.queue")
    }

    func testAsyncSourceLoading() {

        var retrivedImage: CGImage? = nil

        let loadingExp = XCTestExpectation()
        loadingExp.assertForOverFulfill = true

        let imageSource = ImageAsyncSource(queue: self.queue) {
            defer { loadingExp.fulfill() }
            return self.testImage
        }

        let gettingExp = XCTestExpectation()
        imageSource.getImage { img in
            defer { gettingExp.fulfill() }
            retrivedImage = img
        }

        self.wait(for: [loadingExp, gettingExp], timeout: 0.1, enforceOrder: true)
        XCTAssertIdentical(retrivedImage, self.testImage)

        retrivedImage = nil
        imageSource.getImage { img in
            retrivedImage = img
        }
        XCTAssertIdentical(retrivedImage, self.testImage)
    }

    func testAsyncSourceFailureThenSuccess() {

        let expectedResults: [CGImage?] = [nil, nil, self.testImage, self.testImage]
        var results: [CGImage?] = []

        let gettingExp = XCTestExpectation()
        gettingExp.expectedFulfillmentCount = expectedResults.count

        var srcIndex = 0
        let imageSource = ImageAsyncSource(queue: self.queue) {
            defer { srcIndex += 1 }
            return expectedResults[srcIndex]
        }

        for _ in 0..<expectedResults.count {
            imageSource.getImage { img in
                results.append(img)
                gettingExp.fulfill()
            }
        }

        self.wait(for: [gettingExp], timeout: 0.1)
        XCTAssertEqual(results,  expectedResults)
    }

    func testCachedImageSourceFailed() {
        let store = MockImageStore()
        let ds = MockImageDataSource()

        let image = CachedImageSource(dataSource: ds, imageId: "", store: store)

        image.getImage { XCTAssertNil($0) }

        self.wait(for: [store.gettingExp, ds.willGetExp], timeout: 0.1, enforceOrder: true)
    }

    func testCachedImageSourceLoadedAndCached() {
        let store = MockImageStore()
        store.savingImage = ImageAsyncSource(queue: self.queue) { self.testImage }

        let ds = MockImageDataSource()
        ds.willGetExp.assertForOverFulfill = true
        ds.data = Data()

        let receiveExp = XCTestExpectation()
        receiveExp.expectedFulfillmentCount = 3
        let image = CachedImageSource(dataSource: ds, imageId: "", store: store)
        for _ in 0..<receiveExp.expectedFulfillmentCount {
            image.getImage { img in
                XCTAssertIdentical(img, self.testImage)
                receiveExp.fulfill()
            }
        }
        self.wait(for: [store.gettingExp, ds.willGetExp, store.didSaveExp, receiveExp],
                  timeout: 0.1, enforceOrder: true)
    }
}

class MockImageDataSource: ImageDataSource {
    var data: Data?
    var willGetExp = XCTestExpectation(description: "DataSource expectation")

    func getData(_ handler: @escaping (Data?)->Void) {
        DispatchQueue.main.async {
            self.willGetExp.fulfill()
            handler(self.data)
        }
    }
}

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
