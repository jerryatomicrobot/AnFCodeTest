//
//  NetworkManager.swift
//  ANF Code Test
//

import Foundation
import UIKit

struct NetworkManager {

    // MARK: Enums

    enum NetworkManagerError: Error {
        case invalidUrl
        case invalidImageData
        case unknown
    }

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

        let (data, _) = try await session.data(from: exploreItemsUrl)
        let decoder = JSONDecoder()

        return try decoder.decode([ExploreItem].self, from: data)
    }

    func downloadImage(url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)

        guard let image = UIImage(data: data) else {
            throw NetworkManagerError.invalidImageData
        }

        return image
    }
}
