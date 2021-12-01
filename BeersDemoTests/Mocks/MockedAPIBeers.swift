//
//  MockedAPIBeers.swift
//  BeersDemoTests
//
//  Created by DIGITAL2 on 30/11/21.
//

import Foundation
import Combine
@testable import BeersDemo

final class MockedAPIBeers: BeersAPIProtocol {

    var calls = 0
    var queriesMade: [String?] = []
    var result: Result<[Beer], Error> = .success([])

    func fetchByFood(query: String?) -> AnyPublisher<[Beer], Error> {
        calls += 1
        queriesMade.append(query)

        return result
            .publisher
            .eraseToAnyPublisher()
    }
}
