//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    // MARK: Vars and Constants

    private lazy var activityIndicator: UIActivityIndicatorView = { UIActivityIndicatorView(style: .large) }()

//    private var exploreData: [ExploreItem]? { return ExploreItem.localExploreItems }
    private var exploreData: [ExploreItem]?

    private static var listToDetailSegueId = "listToDetailSegue"

    static var storyboardId = "\(ANFExploreCardTableViewController.self)"

    // View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Explore!"
        self.navigationItem.backButtonTitle = ""

        setupView()
        loadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = ANFExploreCardTableViewController.listToDetailSegueId

        guard segue.identifier == segueId,
              let detailsVC = segue.destination as? DetailsViewController,
              let exploreItem = sender as? ExploreItem else {
            return
        }

        detailsVC.exploreItem = exploreItem
    }

    // MARK: Setup Methods

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

                exploreData = try await NetworkManager.shared.loadExploreItems()

                tableView.reloadData()
                hideActivityIndicator()
            } catch {
                print("Error: \(error.localizedDescription)")
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

    // MARK: TableViewDataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableId = ExploreContentTableViewCell.reusableId

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath) as? ExploreContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.exploreItem = exploreData?[indexPath.row]

        return cell
    }

    // MARK: TableViewDelegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get cell and unselect it:
        guard let cell = tableView.cellForRow(at: indexPath) as? ExploreContentTableViewCell else {
            return
        }

        cell.setSelected(false, animated: true)

        let segueId = ANFExploreCardTableViewController.listToDetailSegueId
        self.performSegue(withIdentifier: segueId, sender: cell.exploreItem)
    }
}
