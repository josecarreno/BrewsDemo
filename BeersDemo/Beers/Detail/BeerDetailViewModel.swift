//
//  BeerDetailViewModel.swift
//  BeersDemo
//

import Foundation
import Combine

final class BeerDetailViewModel {
    @Published var name: String = ""
    @Published var tagline: String = ""
    @Published var imageURL: URL? = nil
    @Published var description: String = ""

    private let beer: Beer

    init(beer: Beer) {
        self.beer = beer

        setUpBindings()
    }

    private func setUpBindings() {
        name = beer.name
        tagline = beer.tagline
        imageURL = URL(string: beer.image_url)
        description = beer.description
    }
}
