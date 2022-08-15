//
//  HTTPRequestTests.swift
//  HungerHeroesTests
//
//  Created by onegray on 15.08.22.
//

import XCTest
@testable import HungerHeroes

class HTTPRequestTests: XCTestCase {

    var request: HTTPRequest!
    let hostString = "www.example.com"
    let endpointPath = "/path/to/endpoint"
    let defaultHeaders = ["Content-Type" : "Text/plain"]
    let defaultParams = ["q" : "value"]

    override func setUpWithError() throws {
        request = HTTPRequest(path: self.endpointPath, method: .get)
        request.headers = self.defaultHeaders
        request.params = self.defaultParams
    }

    func testPrepareUrl() {
        let url = try! self.request.prepareUrl(baseUrl: URL(string: hostString)!)
        XCTAssertEqual(url.baseURL!.absoluteString, hostString)
        XCTAssertEqual(url.absoluteString, "///path/to/endpoint?q=value")
    }

    func testPrepareHeaders() {
        self.request.headers = ["header" : "value"]
        let resultHeaders = self.request.prepareHeaders(defaultHeaders: self.defaultHeaders)
        XCTAssertEqual(resultHeaders, ["Content-Type" : "Text/plain", "header" : "value"])
    }

    func testUrlEncodedBody() {
        let bodyData = try! self.request.urlEncodedBody()!
        let bodyString = String(data: bodyData, encoding: .utf8)
        XCTAssertEqual(bodyString, "q=value")
    }

    func testJsonEncodedBody() {
        let bodyData = try! self.request.jsonEncodedBody()!
        let bodyJson = try! JSONDecoder().decode([String : String].self, from: bodyData)
        XCTAssertEqual(bodyJson, self.defaultParams)
    }

    func testPrepareQueryItems() {
        let queryItems = self.request.prepareQueryItems()
        XCTAssertEqual(queryItems, [URLQueryItem(name: "q", value: "value")])
    }
}
