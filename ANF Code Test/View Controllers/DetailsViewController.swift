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

        setupBackgroundImage()

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

    private func setupBackgroundImage() {
        guard let exploreItem else { return }

        // Attempt to set background image assuming that the obtained `backgroundImage` string is an Assets image:
        self.bgImageView.image = UIImage(named: exploreItem.backgroundImageString)

        guard let backgroundImageUrl = exploreItem.backgroundImageUrl,
              bgImageView.image == nil else {
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
