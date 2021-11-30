//
//  BeersAPI.swift
//  BeersDemo
//

import Foundation
import Combine

enum APIError: Error {
    case malformedURL
    case decode
    case unknown
}

protocol BeersAPIProtocol {
    func fetchByFood(query: String?) -> AnyPublisher<[Beer], Error>
}

final class BeersAPI: BeersAPIProtocol {

    func fetchByFood(query: String?) -> AnyPublisher<[Beer], Error> {
        var dataTask: URLSessionDataTask?

        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        return Future<[Beer], Error> { [weak self] promise in
            guard let urlRequest = self?.buildURLRequest(query: query) else {
                promise(.failure(APIError.malformedURL))
                return
            }

            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))

                        return
                    }

                    promise(.failure(APIError.unknown))

                    return
                }

                guard let beers = try? JSONDecoder().decode(
                        [Beer].self, from: data) else {
                    promise(.failure(APIError.decode))

                    return
                }

                promise(.success(beers))
            }
        }
        .handleEvents(receiveSubscription: onSubscription,
                      receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    private func buildURLRequest(query: String?) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.punkapi.com"
        components.path = "/v2/beers"
        if let query = query, !query.isEmpty {
            let sanitizedQuery = query.replacingOccurrences(of: " ", with: "_")

            components.queryItems = [
                URLQueryItem(name: "food", value: sanitizedQuery)
            ]
        }

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15.0

        return request
    }
}
