//
//  BooksTableViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksTableViewModel: NSObject {
    var lastPage = 0

    var volumes: [Volume] = [] {
        didSet {
            guard let onDataReload = onDataReload else {
                return
            }
            onDataReload()
        }
    }

    var onDataReload: (() -> Void)?

    var query = ""

    var nextPageFetchLock = true

    func searchNewQuery() {
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: 0) { data, error  in
            guard let volumes = data?.items else { return }
            self.lastPage = 0
            self.volumes = volumes
        }
    }

    func fetchNextPage() {
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: lastPage) { data, error  in
            guard let volumes = data?.items else { return }
            self.volumes += volumes
            self.nextPageFetchLock = true
        }
    }
}

extension BooksTableViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableCell.identifier, for: indexPath)
        cell.textLabel?.text = "Test \(indexPath.row)"
        reloadNextPageOnIndexPathThreshold(indexPath, threshold: 7 * volumes.count / 8)
        return cell
    }

    func reloadNextPageOnIndexPathThreshold(_ indexPath: IndexPath, threshold: Int) {
        if indexPath.row >= threshold && nextPageFetchLock {
            nextPageFetchLock = false
            lastPage += 1
            fetchNextPage()
        }
    }
}
