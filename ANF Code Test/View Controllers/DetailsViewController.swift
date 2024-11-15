//
//  DetailsViewController.swift
//  ANF Code Test
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var topDescLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var promoLabel: UILabel!
    @IBOutlet private weak var bottomDescTextView: UITextView!
    @IBOutlet private weak var buttonsStackView: UIStackView!

    // MARK: Vars and Constants

    private var contentButtons: [ContentButton] = []

    private var bottomDescAttributedString: NSAttributedString? {
        guard let exploreItem = self.exploreItem,
              let bottomDescription = exploreItem.bottomDescription,
              let htmlData = bottomDescription.data(using: .unicode),
              let attributedText = try? NSMutableAttributedString(data: htmlData,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html],
                                                                  documentAttributes: nil) else {
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

    var exploreItem: ExploreItem?

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Text View link attributes:
        bottomDescTextView.linkTextAttributes = bottomDescriptionAttributes

        updateViewContent()
    }

    // MARK: Private Utility Methods

    private func updateViewContent() {
        guard let exploreItem else {
            resetViewsContent()
            return
        }

        bgImageView.image = UIImage(named: exploreItem.backgroundImage)
        topDescLabel.text = exploreItem.topDescription
        titleLabel.text = exploreItem.title
        promoLabel.text = exploreItem.promoMessage

        generateContentButtons()

        guard let attributedText = bottomDescAttributedString else {
            bottomDescTextView.text = nil
            return
        }

        bottomDescTextView.attributedText = attributedText
    }

    private func resetViewsContent() {
        bgImageView.image = nil
        topDescLabel.text = nil
        titleLabel.text = nil
        promoLabel.text = nil
        bottomDescTextView.text = nil

        contentButtons.forEach { $0.removeFromSuperview() }
    }

    private func generateContentButtons() {
        guard let contentList = exploreItem?.content else {
            return
        }

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
}
