//
//  ExploreContentTableViewCell.swift
//  ANF Code Test
//

import UIKit

class ExploreContentTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var topDescLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var promoLabel: UILabel!
    @IBOutlet private weak var bottomDescTextView: UITextView!
    @IBOutlet private weak var descTextStackView: UIStackView!
    @IBOutlet private weak var buttonsStackView: UIStackView!

    // MARK: Vars and Constants

    static var nibName = "\(ExploreContentTableViewCell.self)"
    static var reusableId = "\(ExploreContentTableViewCell.self)"

    var exploreItem: ExploreItem? {
        didSet {
            updateCellContent()
        }
    }

    private(set) var contentButtons: [ContentButton] = []

    private var bottomDescAttributedString: NSAttributedString? {
        guard let exploreItem = self.exploreItem,
              let bottomDescription = exploreItem.bottomDescription,
              let htmlData = bottomDescription.data(using: .unicode),
              let attributedText = try? NSMutableAttributedString(
                data: htmlData,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
        else {
            return nil
        }

        let range = NSRange(location: 0, length: attributedText.length)

        attributedText.addAttributes(bottomDescriptionAttributes, range: range)

        return attributedText
    }

    private var bottomDescriptionAttributes: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        return [.paragraphStyle: paragraph, .font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.systemGray3]
    }

    // NOTE: The following computed vars are for unit testing purposes only:

    var image: UIImage? { bgImageView.image }
    var topDescription: String? { topDescLabel.text }
    var title: String? { titleLabel.text }
    var promo: String? { promoLabel.text }
    var bottomDescription: NSAttributedString? { bottomDescTextView.attributedText }

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
        
        setupBackgroundImage()

        topDescLabel.text = exploreItem.topDescription
        titleLabel.text = exploreItem.title
        promoLabel.text = exploreItem.promoMessage

        generateContentButtons()

        guard let attributedText = bottomDescAttributedString else {
            bottomDescTextView.text = nil
            bottomDescTextView.attributedText = nil
            descTextStackView.isHidden = true

            return
        }

        // Setup Text View link attributes:
        bottomDescTextView.linkTextAttributes = bottomDescriptionAttributes

        descTextStackView.isHidden = false
        bottomDescTextView.attributedText = attributedText
    }

    private func setupBackgroundImage() {
        guard let exploreItem else { return }

        guard let backgroundImageUrl = exploreItem.backgroundImageUrl else {
            return
        }

        // Re-attempt to fetch the image from the web.
        // The URLSession instance uses the `NSURLRequestUseProtocolCachePolicy` as default.
        // Therefore, if this image has been already downloaded (at the previous view controller),
        // the request should just retrieve the cached image from the local storage,
        // and complete the request successfully:

        Task {
            do {
                let image = try await NetworkManager.shared.downloadImage(url: backgroundImageUrl)

                bgImageView.image = image

            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func generateContentButtons() {
        guard let contentList = exploreItem?.content else {
            buttonsStackView.isHidden = true
            return
        }

        buttonsStackView.isHidden = false

        // Remove any existing buttons on the stack view:
        buttonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        contentList.forEach {

            let button = ContentButton()
            button.setTitle($0.title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true

            buttonsStackView.addArrangedSubview(button)
            contentButtons.append(button)

            guard let url = $0.targetUrl, UIApplication.shared.canOpenURL(url) else {
                return
            }

            let action = UIAction() { _ in
                UIApplication.shared.open(url)
            }

            button.addAction(action, for: .touchUpInside)
        }
    }

    private func resetViewsContent() {
        bgImageView.image = nil
        topDescLabel.text = nil
        titleLabel.text = nil
        promoLabel.text = nil
        bottomDescTextView.text = nil

        contentButtons.forEach { $0.removeFromSuperview() }
    }
}
