//
//  XCTestCase+Extensions.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import XCTest
import Combine

extension XCTestCase {

    func waitSequence<T>(publisher: AnyPublisher<T, Never>, count: Int,
                         timeout: TimeInterval, trigger: (()->Void)? = nil) -> [T] {

        let exp = XCTestExpectation()
        exp.expectedFulfillmentCount = count
        var receivedValues = [T]()

        var disposeBag = Set<AnyCancellable>()

        publisher.sink { value in
            receivedValues.append(value)
            exp.fulfill()
        }
        .store(in: &disposeBag)

        trigger?()

        self.wait(for: [exp], timeout: timeout)

        return receivedValues
    }
}
