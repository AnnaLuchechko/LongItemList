//
//  ItemsListViewController.swift
//  LongItemList
//
//  Created by Anna Luchechko on 02.04.2021.
//

import UIKit

protocol ItemsListViewProtocol {
    func setupUI()
    func fetchItems()
    func isLoadingCell(for indexPath: IndexPath) -> Bool
    func reloadRows(with newItems: [ListItemModel])
}

class ItemsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableIndicatorView: UIActivityIndicatorView!
    
    private let limit = 10000
    private var totalCount = 1000000
    private var listItems: [ListItemModel] = []
    private var isFetchInProgress = false
    
    let interaction = ItemsListInteraction()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchItems()
    }

}

extension ItemsListViewController: ItemsListViewProtocol {
    func fetchItems() {
        guard !isFetchInProgress else { return }
          
        isFetchInProgress = true
        
        let startingIndex = listItems.count
        interaction.fetchListItems(from: startingIndex, limit: limit, completion: { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                }
            case .success(let list):
                DispatchQueue.main.async {
                    self.tableIndicatorView.stopAnimating()
                    self.tableIndicatorView.isHidden = true
                    self.tableView.isHidden = false
                    self.isFetchInProgress = false
                    self.listItems.append(contentsOf: list.items)
                    self.reloadRows(with: list.items)
                }
            }
        })
    }
    
    func setupUI() {
        tableIndicatorView.startAnimating()
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= listItems.count
    }
    
    func reloadRows(with newItems: [ListItemModel]) {
        let calculateIndexPaths = self.calculateIndexPathsToReload(from: newItems)
        let indexPaths = visibleIndexPathsToReload(intersecting: calculateIndexPaths)
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
    
    private func calculateIndexPathsToReload(from newItems: [ListItemModel]) -> [IndexPath] {
      let startIndex = listItems.count - newItems.count
      let endIndex = startIndex + newItems.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

extension ItemsListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      fetchItems()
    }
  }
}

extension ItemsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ItemsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsListTableViewCell", for: indexPath) as? ItemsListTableViewCell else { return ItemsListTableViewCell() }
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: listItems[indexPath.row])
        }
        return cell
    }
}
