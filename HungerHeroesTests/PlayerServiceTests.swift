//
//  PlayerServiceTests.swift
//  HungerHeroesTests
//
//  Created by sergeyn on 23.11.22.
//

import Combine
import XCTest
@testable import HungerHeroes

class PlayerServiceTests: XCTestCase {

    var playerService: AppPlayerService!

    let mockStorage = MockStorage()
    let mockApiClient = MockApiClient()

    override func setUp() {
        super.setUp()
        self.playerService = AppPlayerService(playerId: 0, storage: self.mockStorage, httpClient: self.mockApiClient)
    }

    func testRequestPlayerProfileLoadingStatus() {

        let loadingExp = XCTestExpectation()
        loadingExp.expectedFulfillmentCount = 3
        var requestingEvents = [Bool]()

        var disposeBag = Set<AnyCancellable>()

        self.playerService.isRequesting
            .sink { isRequesting in
                requestingEvents.append(isRequesting)
                loadingExp.fulfill()
            }
            .store(in: &disposeBag)

        self.playerService.requestPlayerProfile()

        self.wait(for: [loadingExp], timeout: 0.1)
        XCTAssertEqual(requestingEvents, [false, true, false])
    }


    func testRequestPlayerProfile() {

        let player = PlayerDef(id: 0, name: "Player", speciality: .snipper, avatar: nil, stats: nil)
        let playerData = try! JSONEncoder().encode(player)
        let response = GetPlayerProfileResponse(data: playerData, code: 0)

        self.mockApiClient.setResponse(response, for: GetPlayerProfileRequest.self)

        let loadingExp = XCTestExpectation()
        var disposeBag = Set<AnyCancellable>()

        self.playerService.player
            .compactMap { $0 }
            .sink { _ in
                loadingExp.fulfill()
            }
            .store(in: &disposeBag)

        self.playerService.requestPlayerProfile()

        self.wait(for: [loadingExp], timeout: 0.1)
        XCTAssertEqual(self.playerService.player.value, player)
    }
}
