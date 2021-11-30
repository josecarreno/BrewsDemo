//
//  BeersViewModel.swift
//  BeersDemo
//

import Foundation
import Combine

enum BeersViewModelError: Error, Equatable {
    case beersFetch
}

enum BeersViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(BeersViewModelError)
}

final class BeersViewModel {
    enum Section { case beers }

    private let beersAPI: BeersAPIProtocol

    @Published private(set) var beers: [Beer] = []
    @Published private(set) var state: BeersViewModelState = .loading

    private var query: String = ""
    private var bindings = Set<AnyCancellable>()

    init(beersAPI: BeersAPIProtocol = BeersAPI()) {
        self.beersAPI = beersAPI
    }

    func search(query: String) {
        self.query = query
        fetchBeers(using: query)
    }

    func retrySearch() {
        fetchBeers(using: query)
    }
}

extension BeersViewModel {
    private func fetchBeers(using searchQuery: String?) {
        state = .loading

        let searchCompletionHandler: (Subscribers.Completion<Error>) -> Void = {
            [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.beersFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }

        let searchValueHandler: ([Beer]) -> Void = { [weak self] beers in
            self?.beers = beers
        }

        beersAPI
            .fetchByFood(query: searchQuery)
            .sink(receiveCompletion: searchCompletionHandler,
                  receiveValue: searchValueHandler)
            .store(in: &bindings)
    }
}
