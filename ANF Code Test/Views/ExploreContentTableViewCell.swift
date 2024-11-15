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

    // NOTE: The following computed vars are for testing purposes only:

    var title: String? { titleLabel.text }
    var image: UIImage? { contentImageView.image }

    // MARK: UITableViewCell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        resetViewsContent()
    }

    // MARK: Private Utility Methods

    private func updateCellContent() {
        guard let exploreItem else {
            resetViewsContent()
            return
        }

        titleLabel.text = exploreItem.title

        guard let backgroundImageUrl = exploreItem.backgroundImageUrl else {
            return
        }

        Task {
            do {
                let image = try await NetworkManager.shared.downloadImage(url: backgroundImageUrl)
                contentImageView.image = image
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func resetViewsContent() {
        titleLabel.text = nil
        contentImageView.image = nil
    }

}
