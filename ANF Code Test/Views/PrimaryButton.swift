//
//  PrimaryButton.swift
//  ANF Code Test
//

import UIKit

@IBDesignable
class PrimaryButton: UIButton {

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if #available(iOS 15.0, *) {
            self.configuration = .primary
        } else {
            let foregroundColor: UIColor = .systemGray

            self.backgroundColor = .clear
            self.setTitleColor(foregroundColor, for: .normal)
            self.layer.borderColor = foregroundColor.cgColor
        }
    }

}
