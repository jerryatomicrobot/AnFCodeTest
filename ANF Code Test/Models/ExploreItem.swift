//
//  ExploreItem.swift
//  ANF Code Test
//

import Foundation


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
    let backgroundImage: String
    let topDescription: String?
    let promoMessage: String?
    let bottomDescription: String?
    let content: [ExploreItemContent]?
}
