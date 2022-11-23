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

    var mockStorage: MockStorage!
    var mockApiClient: MockApiClient!

    var playerService: AppPlayerService!

    override func setUp() {
        super.setUp()
        self.mockApiClient = MockApiClient()
        self.mockStorage = MockStorage()
        self.playerService = AppPlayerService(playerId: 0, storage: self.mockStorage, httpClient: self.mockApiClient)
    }

    func testRequestPlayerProfileLoadingStatus() {

        let isLoadingPublisher = self.playerService.isRequesting.eraseToAnyPublisher()

        let result = self.waitSequence(publisher: isLoadingPublisher, count: 3, timeout: 0.1) {
            self.playerService.requestPlayerProfile()
        }

        XCTAssertEqual(result, [false, true, false])
    }

    func testRequestPlayerProfile() {

        let player = PlayerDef(id: 0, name: "Player", speciality: .snipper, avatar: nil, stats: nil)
        let playerData = try! JSONEncoder().encode(player)
        let response = GetPlayerProfileResponse(data: playerData, code: 0)

        self.mockApiClient.setResponse(response, for: GetPlayerProfileRequest.self)

        let playerPublisher = self.playerService.player.eraseToAnyPublisher()

        let result = self.waitSequence(publisher: playerPublisher, count: 2, timeout: 0.1) {
            self.playerService.requestPlayerProfile()
        }

        XCTAssertEqual(result, [nil, player])
        XCTAssertEqual(self.mockStorage.mockPlayer, player)
    }
}
