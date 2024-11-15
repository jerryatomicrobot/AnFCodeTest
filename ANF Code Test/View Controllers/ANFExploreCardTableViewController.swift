//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    // MARK: Vars and Constants

    private var exploreData: [ExploreItem]? {
        let decoder = JSONDecoder()

        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let exploreItems = try? decoder.decode([ExploreItem].self, from: fileContent) {

            return exploreItems
        }

        return nil
    }

    private static var listToDetailSegueId = "listToDetailSegue"

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
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }
}
