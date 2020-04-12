//
//  BooksTableViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksGridViewModel: NSObject {
    var volumes: [Volume] = [] {
        didSet {
            if oldValue.count == volumes.count && !fetchNewDataLock {
                return
            }
            guard let onDataReload = onDataReload else { return }
            onDataReload()
        }
    }

    var navbarRightButtonText: String {
        return showQueryBooks ? "Favorites" : "Search"
    }

    var showQueryBooks: Bool = true {
        didSet {
            guard let onViewModeChanged = onViewModeChanged else { return }
            onViewModeChanged()
        }
    }

    var lastPage = 0
    var favorites = Set<Volume>()
    var onDataReload: (() -> Void)?
    var onViewModeChanged: (() -> Void)?
    var onSingleRowReload: ((IndexPath) -> Void)?
    var query = ""
    var nextPageFetchLock = true
    var fetchNewDataLock = false

    func searchNewQuery() {
        fetchNewDataLock = true
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: 0) { data, _  in
            guard let volumes = data?.items else { return }
            self.lastPage = 0
            self.volumes = volumes
            self.fetchNewDataLock = false
        }
    }

    func fetchNextPage() {
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: lastPage) { data, _  in
            guard let volumes = data?.items else { return }
            self.volumes += volumes
            self.nextPageFetchLock = true
        }
    }

    func reloadNextPageOnIndexPathThreshold(_ indexPath: IndexPath, threshold: Int) {
        if indexPath.row >= threshold && nextPageFetchLock && showQueryBooks {
            nextPageFetchLock = false
            lastPage += 1
            fetchNextPage()
        }
    }

    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onBookFavorited(_:)), name: BookCollectionCell.favoriteABookNotificationId, object: nil)
    }

    @objc
    func onBookFavorited(_ notification: Notification) {
        guard let indexPath = notification.userInfo?["indexPath"] as? IndexPath else { return }
        volumes[indexPath.row].favorited = true
        favorites.insert(volumes[indexPath.row])
        guard let onSingleRowReload = onSingleRowReload else { return }
        onSingleRowReload(indexPath)
    }

    @objc
    func toggleViewMode() {
        showQueryBooks.toggle()
        if showQueryBooks {
            searchNewQuery()
            return
        }
        volumes = Array(favorites)
    }
}

extension BooksGridViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return volumes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCell.identifier, for: indexPath) as? BookCollectionCell

        volumes[indexPath.row].favorited = favorites.contains(volumes[indexPath.row])
        cell?.viewModel.model = volumes[indexPath.row]
        reloadNextPageOnIndexPathThreshold(indexPath, threshold: volumes.count - 1)

        return cell ?? UICollectionViewCell()
    }
}
