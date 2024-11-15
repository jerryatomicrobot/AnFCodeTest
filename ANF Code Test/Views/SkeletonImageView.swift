//
//  SkeletonImageView.swift
//  ANF Code Test
//

import UIKit

@IBDesignable
class SkeletonImageView: UIImageView {

    override var image: UIImage? {
            didSet {
                super.image = image
                
                setupImgView()
            }
        }

    // MARK: View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        setupImgView()
    }

    // MARK: Setup Methods

    private func setupImgView() {
        if image != nil {
            self.layer.cornerRadius = 0
            self.backgroundColor = .clear
        } else {
            self.layer.cornerRadius = 8
            self.backgroundColor = .gray
        }
    }
}
