//
//  AlamofireMock.swift
//  RecipleaseTests
//
//  Created by Nicolas SERVAIS on 04/11/2021.
//
//@testable import Reciplease
import Foundation
import Alamofire

struct MockResponse {
    var response: HTTPURLResponse?
    var data: Data?
}

final class MockRecipeSession: AlamofireSession {
    private let mockResponse: MockResponse
    init(mockResponse: MockResponse) {
        self.mockResponse = mockResponse
    }
    func request(with url: URL, completion: @escaping (AFDataResponse<Any>) -> Void) {
        let dataResponse = AFDataResponse<Any>(request: nil, response: mockResponse.response, data: mockResponse.data, metrics: nil, serializationDuration: 0, result: .success("OK"))
        completion(dataResponse)
    }
}
