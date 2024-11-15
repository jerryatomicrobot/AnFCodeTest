//
//  ExploreItem.swift
//  ANF Code Test
//

import Foundation
import UIKit

// MARK: Enums

enum ElementType {
    case hyperlink
    case unknown

    var keyValue: String {
        switch self {
        case .hyperlink:
            return "hyperlink"
        default:
            return ""
        }
    }
}

struct ExploreItemContent: Codable {

    let elementType: ElementType
    let targetUrlString: String
    let title: String

    var targetUrl: URL? { URL(string: targetUrlString) }

    enum CodingKeys: String, CodingKey {
        case elementType
        case target
        case title
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let elementTypeString: String? = try values.decodeIfPresent(String.self, forKey: .elementType)

        if let elementTypeString {
            switch elementTypeString {
            case ElementType.hyperlink.keyValue:
                elementType = .hyperlink
            default:
                elementType = .unknown
            }
        } else {
            elementType = .unknown
        }

        targetUrlString = try values.decode(String.self, forKey: .target)
        title = try values.decode(String.self, forKey: .title)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(elementType.keyValue, forKey: .elementType)
        try container.encode(targetUrlString, forKey: .target)
        try container.encode(title, forKey: .title)
    }
}

struct ExploreItem: Codable {

    let title: String
    let backgroundImageString: String
    let topDescription: String?
    let promoMessage: String?
    let bottomDescription: String?
    let content: [ExploreItemContent]?

    var backgroundImageUrl: URL? { URL(string: self.backgroundImageString) }

    var backgroundImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case title
        case backgroundImageString = "backgroundImage"
        case topDescription
        case promoMessage
        case bottomDescription
        case content
    }
}

extension ExploreItem {

    // NOTE: The following computed vars have been encapsulated here as an extension of `ExploreItem` not only to
    // avoid code duplication, but also for unit test purposes:

    static var localExploreData: Data? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {

            return fileContent
        }

        return nil
    }

    static var localExploreItems: [ExploreItem]? {
        let decoder = JSONDecoder()

        if let fileContent = ExploreItem.localExploreData,
           let exploreItems = try? decoder.decode([ExploreItem].self, from: fileContent) {

            return exploreItems
        }

        return nil
    }
}
