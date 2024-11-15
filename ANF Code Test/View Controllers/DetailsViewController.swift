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
    @IBOutlet private weak var bottomDescLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!

    // MARK: Vars and Constants

    private var contentButtons: [PrimaryButton]?

    var exploreItem: ExploreItem?

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        promoLabel.text = exploreItem.promoMessage // TODO: Update with attributed string
        bottomDescLabel.text = exploreItem.bottomDescription
    }

    private func resetViewsContent() {
        bgImageView.image = nil
        topDescLabel.text = nil
        titleLabel.text = nil
        promoLabel.text = nil
        bottomDescLabel.text = nil

        contentButtons?.forEach { $0.removeFromSuperview() }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
