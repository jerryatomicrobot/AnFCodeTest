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

    static var nibName = "\(ExploreContentTableViewCell.self)"
    static var reusableId = "\(ExploreContentTableViewCell.self)"

    var exploreItem: ExploreItem? {
        didSet {
            updateCellContent()
        }
    }

    // MARK: UITableViewCell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        resetViewsContent()
    }

    // MARK: Private Utility Methods

    private func updateCellContent() {
        guard exploreItem != nil else {
            resetViewsContent()
            return
        }

        titleLabel.text = exploreItem?.title

        if let backgroundImageString = exploreItem?.backgroundImage {
            contentImageView.image = UIImage(named: backgroundImageString)
        }
    }

    private func resetViewsContent() {
        titleLabel.text = ""
        contentImageView.image = nil
    }

}
