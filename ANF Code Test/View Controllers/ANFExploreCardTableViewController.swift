//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    // MARK: Vars and Constants

    private lazy var activityIndicator: UIActivityIndicatorView = { UIActivityIndicatorView(style: .large) }()

    var exploreItems: [ExploreItem]?

    static var storyboardId = "\(ANFExploreCardTableViewController.self)"

    // View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Explore!"
        self.navigationItem.backButtonTitle = ""

        setupView()
        loadData()
    }

    // MARK: Setup/Utility Methods

    private func setupView() {
        self.view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }

    private func loadData() {
        Task {
            do {
                showActivityIndicator()

                exploreItems = try await NetworkManager.shared.loadExploreItems()

                tableView.reloadData()
                hideActivityIndicator()
            } catch {
                showErrorAlert(error)
                hideActivityIndicator()
            }
        }
    }

    private func showActivityIndicator() {
        tableView.isHidden = true
        activityIndicator.isHidden = false
    }

    private func hideActivityIndicator() {
        tableView.isHidden = false
        activityIndicator.isHidden = true
    }

    private func showErrorAlert(_ error: Error) {
        print("Error: \(error.localizedDescription)")
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let retryAction = UIAlertAction(title: "RETRY", style: .cancel) { _ in
            self.loadData()
        }

        let errorMsg: String
        if let error = error as? NetworkManagerError {
            errorMsg = error.localizedDescription
        } else {
            errorMsg = error.localizedDescription
        }

        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        alertController.addAction(okAction)
        alertController.addAction(retryAction)

        present(alertController, animated: true)
    }

    // MARK: TableViewDataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableId = ExploreContentTableViewCell.reusableId

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath) as? ExploreContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.exploreItem = exploreItems?[indexPath.row]

        return cell
    }

    // MARK: TableViewDelegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get cell and unselect it:
        guard let cell = tableView.cellForRow(at: indexPath) as? ExploreContentTableViewCell else {
            return
        }

        cell.setSelected(false, animated: true)
    }
}
