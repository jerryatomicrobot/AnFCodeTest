//
//  NetworkManager.swift
//  ANF Code Test
//

import Foundation
import UIKit

// MARK: Enums

enum NetworkManagerError: Error {
    case invalidUrl
    case invalidResponse
    case badRequest
    case invalidImageData
    case serverNotFound
    case invalidServerError
    case unknown

    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "The provided URL is invalid."
        case .invalidResponse:
            return "The received data is invalid."
        case .badRequest:
            return "The request is invalid."
        case .invalidImageData:
            return "The data or the image is invalid."
        case .serverNotFound, .invalidServerError:
            return "There was a problem attempting to connect. Please try again later."
        case .unknown:
            return "Unknown error. Please try again later."
        }
    }
}

struct NetworkManager {

    // MARK: Vars and Constants

    static let shared = NetworkManager()

    private var session = URLSession.shared

    private let baseUrl = "https://www.abercrombie.com"
    private let exploreItemsEndpoint = "/anf/nativeapp/qa/codetest/codeTest_exploreData.json"

    private var exploreItemsWebUrl: URL? { URL(string: baseUrl + exploreItemsEndpoint) }

    private var exploreItemsLocalUrl: URL? {
        guard let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json") else {
            return nil
        }

        return URL(fileURLWithPath: filePath)
    }

    func loadExploreItems() async throws -> [ExploreItem] {
        guard let exploreItemsUrl = exploreItemsWebUrl else {
            throw NetworkManagerError.invalidUrl
        }

        let data = try await self.performRequest(url: exploreItemsUrl)

        let decoder = JSONDecoder()

        return try decoder.decode([ExploreItem].self, from: data)
    }

    func downloadImage(url: URL) async throws -> UIImage {
        let data = try await self.performRequest(url: url)

        guard let image = UIImage(data: data) else {
            throw NetworkManagerError.invalidImageData
        }

        return image
    }

    private func performRequest(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkManagerError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 400...403:
            throw NetworkManagerError.badRequest
        case 404:
            throw NetworkManagerError.serverNotFound
        case 500:
            throw NetworkManagerError.invalidServerError
        default:
            throw NetworkManagerError.unknown
        }
    }
}
