//
//  ExploreContentTableViewCell.swift
//  ANF Code Test
//

import UIKit

class ExploreContentTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentImageView: UIImageView!

    // MARK: Vars and Constants

    var exploreItem: ExploreItem? {
        didSet {
            
        }
    }

    // MARK: Private Utility Methods

    private func updateCellContent() {
        guard exploreItem != nil else {
            resetViewsContent()
            return
        }

//        titleLabel.text = ""
//        contentImageView.image = nil
    }

    private func resetViewsContent() {
        titleLabel.text = ""
        contentImageView.image = nil
    }

}
