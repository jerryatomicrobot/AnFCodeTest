//
//  UIButtonConfiguration+ANF.swift
//  ANF Code Test
//

import UIKit

@available(iOS 15.0, *)
extension UIButton.Configuration {

    static let primary: Self = {

        var configuration: UIButton.Configuration = .bordered()
        let foregroundColor: UIColor = .systemGray

        // Primary configuration general setup:

        configuration.buttonSize = .large
        configuration.cornerStyle = .fixed
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = foregroundColor

        // Border setup:
        configuration.background.cornerRadius = 0
        configuration.background.strokeColor = foregroundColor
        configuration.background.strokeWidth = 2.0

        // Title text setup
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
            var container = container

            container.font = .system(size: 15.0)

            return container
        }

        return configuration
    }()
}
