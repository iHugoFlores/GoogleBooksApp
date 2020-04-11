//
//  BooksTableViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksGridViewModel: NSObject {
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

    func reloadNextPageOnIndexPathThreshold(_ indexPath: IndexPath, threshold: Int) {
        if indexPath.row >= threshold && nextPageFetchLock {
            nextPageFetchLock = false
            lastPage += 1
            fetchNextPage()
        }
    }
}

extension BooksGridViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return volumes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCell.identifier, for: indexPath) as? BookCollectionCell

        cell?.row = indexPath.row
        cell?.viewModel.model = volumes[indexPath.row]
        reloadNextPageOnIndexPathThreshold(indexPath, threshold: volumes.count - 4)

        return cell ?? UICollectionViewCell()
    }
}
