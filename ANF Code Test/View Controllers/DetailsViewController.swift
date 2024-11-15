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

    private var contentButtons: [PrimaryButton]?

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

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

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

        guard let attributedText = bottomDescAttributedString else {
            bottomDescTextView.attributedText = NSAttributedString(string: "")
            return
        }

        bottomDescTextView.attributedText = attributedText
    }

    private func resetViewsContent() {
        bgImageView.image = nil
        topDescLabel.text = nil
        titleLabel.text = nil
        promoLabel.text = nil
        bottomDescTextView.attributedText = NSAttributedString(string: "")

        contentButtons?.forEach { $0.removeFromSuperview() }
    }
}
