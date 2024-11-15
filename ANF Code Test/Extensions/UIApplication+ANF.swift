//
//  UIApplication+ANF.swift
//  ANF Code Test
//

import UIKit

extension UIApplication {
    static var useLocalExploreData: Bool {
        Bundle.main.object(forInfoDictionaryKey: "ANF_UseLocalExploreData") as? Bool ?? false
    }
}
