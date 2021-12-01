//
//  BeersViewModelTests.swift
//  BeersDemoTests
//

import XCTest
import Combine
@testable import BeersDemo

class BeersViewModelTests: XCTestCase {

    private var mockedAPIService: MockedAPIBeers!
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: BeersViewModel!

    override func setUp() {
        super.setUp()

        mockedAPIService = MockedAPIBeers()
        viewModel = BeersViewModel(beersAPI: mockedAPIService)
    }

    override func tearDown() {
        super.tearDown()

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        // Make properties nil just in case
        mockedAPIService = nil
        viewModel = nil
    }

    func test_search_shouldCallAPI() {
        // when
        viewModel.search(query: "Test")

        // then
        XCTAssertEqual(mockedAPIService.calls, 1)
        XCTAssertEqual(mockedAPIService.queriesMade.first!, "Test")
    }

    func test_retry_givenTwoPreviousSearches_shouldCallAPIUsingLastQuery() {
        // given
        viewModel.search(query: "Test")

        XCTAssertEqual(mockedAPIService.calls, 1)
        XCTAssertEqual(mockedAPIService.queriesMade.first!, "Test")

        viewModel.search(query: "Test2")

        XCTAssertEqual(mockedAPIService.calls, 2)
        XCTAssertEqual(mockedAPIService.queriesMade[1]!, "Test2")

        // when
        viewModel.retrySearch()

        // then
        XCTAssertEqual(mockedAPIService.calls, 3)
        XCTAssertEqual(mockedAPIService.queriesMade.last!, "Test2")
    }

    func test_search_givenASuccessOnAPICall_shouldUpdateBeers() {
        // given
        mockedAPIService.result = .success(MockedAPIBeers.Examples.beers)

        // when
        viewModel.search(query: "Test")

        // then
        XCTAssertEqual(mockedAPIService.calls, 1)
        XCTAssertEqual(mockedAPIService.queriesMade.first!, "Test")
        viewModel.$beers
            .sink { XCTAssertEqual($0, MockedAPIBeers.Examples.beers) }
            .store(in: &cancellables)

        viewModel.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }

    func test_search_givenAnErrorOnAPICall_shouldUpdateStateAsError() {
        // given
        mockedAPIService.result = .failure(BeersViewModelError.beersFetch)

        // when
        viewModel.search(query: "Test")

        // then
        XCTAssertEqual(mockedAPIService.calls, 1)
        XCTAssertEqual(mockedAPIService.queriesMade.first!, "Test")

        viewModel.$beers
            .sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)

        viewModel.$state
            .sink { XCTAssertEqual($0, .error(BeersViewModelError.beersFetch)) }
            .store(in: &cancellables)
    }
}

extension MockedAPIBeers {
    struct Examples {
        static let buzzBeer: Beer = .init(
            name: "Buzz",
            tagline: "A Real Bitter Experience.",
            description:
                """
            A light, crisp and bitter IPA brewed with English
            and American hops. A small batch brewed only once.
            """,
            image_url: "https://images.punkapi.com/v2/keg.png")

        static let trashyBlondeBeer: Beer = .init(
            name: "Trashy Blonde",
            tagline: "You Know You Shouldn't",
            description:
                """
            A titillating, neurotic, peroxide punk of a Pale Ale. Combining
            attitude, style, substance, and a little bit of low self esteem
            for good measure; what would your mother say? The seductive lure of
            the sassy passion fruit hop proves too much to resist. All that is
            even before we get onto the fact that there are no additives,
            preservatives, pasteurization or strings attached.
            All wrapped up with the customary BrewDog bite and imaginative twist.
            """,
            image_url: "https://images.punkapi.com/v2/2.png")

        static let beers: [Beer] = [buzzBeer, trashyBlondeBeer]
    }
}
