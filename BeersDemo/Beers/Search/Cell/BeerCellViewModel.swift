//
//  BeerCellViewModel.swift
//  BeersDemo
//

import Foundation
import Combine

final class BeerCellViewModel {
    @Published var name: String = ""

    private let beer: Beer

    init(beer: Beer) {
        self.beer = beer

        setUpBindings()
    }

    private func setUpBindings() {
        name = beer.name
    }
}
