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
    private let exploreItemsEndpoint = "/anf/nativeapp/qa/codetest/codeTest_exploreData.css"

    private var exploreItemsUrl: URL? {
        if UIApplication.useLocalExploreData == false {
            // Send over web URL:
            return URL(string: baseUrl + exploreItemsEndpoint)
        }

        guard let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json") else {
            return nil
        }

        // Send over local data URL:
        return URL(fileURLWithPath: filePath)
    }
    
    /// Loads and returns an array of `ExploreItem` objects from either the local data or the web (See `ANF_UseLocalExploreData` at `Info.plist`).
    /// - Returns: An array of `ExploreItem` objects
    func loadExploreItems() async throws -> [ExploreItem] {

        guard let exploreItemsUrl else {
            throw NetworkManagerError.invalidUrl
        }

        let data = try await self.performRequest(url: exploreItemsUrl)

        let decoder = JSONDecoder()

        return try decoder.decode([ExploreItem].self, from: data)
    }
    
    /// Downloads an image with the given URL asynchronously.
    /// - Parameter url: The image URL
    /// - Returns: the downloaded `UIImage` instance
    func downloadImage(url: URL) async throws -> UIImage {
        if await UIApplication.useLocalExploreData == true {
            // Attempt to get the image from the Assets catalog:
            let image = UIImage(named: url.absoluteString)

            if let image {
                return image
            } else {
                throw NetworkManagerError.invalidImageData
            }
        }

        let data = try await self.performRequest(url: url)

        guard let image = UIImage(data: data) else {
            throw NetworkManagerError.invalidImageData
        }

        return image
    }

    private func performRequest(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)

        if await UIApplication.useLocalExploreData == true {
            // Return the data, because this was not an HTTP request:
            return data
        }

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
