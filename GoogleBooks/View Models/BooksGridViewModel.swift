//
//  BooksTableViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksGridViewModel: NSObject {
    // MARK: Parameters
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
    var totalVolumes = 0
    var favorites = Set<Volume>()
    var onDataReload: (() -> Void)?
    var onViewModeChanged: (() -> Void)?
    var onSingleRowReload: ((IndexPath) -> Void)?
    var query = "" {
        didSet {
            if query.isEmpty {
                volumes = []
            }
        }
    }
    var nextPageFetchLock = true
    var fetchNewDataLock = false
    var canFetchNextPage: Bool {
        return volumes.count < totalVolumes
    }

    // MARK: Core Data context
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

     // MARK: Set store data
    func retrieveFavorites() {
        do {
            let stored: [VolumeCD] = try context.fetch(VolumeCD.fetchRequest())
            favorites = Set(stored.map { element in
                let imageLinks = element.thumbnail != nil
                    ? ImageLinks(smallThumbnail: element.thumbnail!, thumbnail: element.thumbnail!)
                    : nil
                let volumeInfo = VolumeInfo(title: element.title!, authors: element.authors as? [String], publisher: nil, publishedDate: nil, description: element.bookDescription, industryIdentifiers: nil, readingModes: nil, pageCount: nil, printType: nil, maturityRating: nil, allowAnonLogging: nil, contentVersion: nil, panelizationSummary: nil, imageLinks: imageLinks, language: nil, previewLink: nil, infoLink: nil, canonicalVolumeLink: nil, subtitle: nil, categories: nil)
                return Volume(id: element.id!, kind: nil, etag: nil, selfLink: nil, volumeInfo: volumeInfo, saleInfo: nil, accessInfo: nil, searchInfo: nil, favorited: element.favorited)
            })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

     // MARK: Execute a new query
    func searchNewQuery() {
        if query.isEmpty {
            volumes = []
            return
        }
        fetchNewDataLock = true
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: 0) { data, _  in
            defer {
                self.fetchNewDataLock = false
                self.lastPage = 0
            }
            guard let totalVolumes = data?.totalItems else { return }
            self.totalVolumes = totalVolumes
            if totalVolumes == 0 {
                self.volumes = []
                return
            }
            guard let volumes = data?.items else { return }
            self.volumes = volumes
        }
    }

     // MARK: Fetch next page of data
    func fetchNextPage() {
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: lastPage) { data, _  in
            guard let volumes = data?.items else { return }
            self.volumes += volumes
            self.nextPageFetchLock = true
        }
    }

     // MARK: Threshold for next page fetch
    func reloadNextPageOnIndexPathThreshold(_ indexPath: IndexPath, threshold: Int) {
        if indexPath.row >= threshold && nextPageFetchLock && showQueryBooks {
            nextPageFetchLock = false
            lastPage += 1
            fetchNextPage()
        }
    }

    // MARK: Favorite book notification method
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

        let book = VolumeCD(entity: VolumeCD.entity(), insertInto: context)
        book.id = volumes[indexPath.row].id
        book.authors = volumes[indexPath.row].volumeInfo.authors as NSObject?
        book.favorited = true
        book.title = volumes[indexPath.row].volumeInfo.title
        book.bookDescription = volumes[indexPath.row].volumeInfo.description
        book.thumbnail = volumes[indexPath.row].volumeInfo.imageLinks?.thumbnail
        appDelegate!.saveContext()
    }

    // MARK: View mode method
    @objc
    func toggleViewMode() {
        showQueryBooks.toggle()
        if showQueryBooks {
            volumes = []
            searchNewQuery()
            return
        }
        volumes = Array(favorites)
    }
}

// MARK: Collection View Delegation
extension BooksGridViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return volumes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCell.identifier, for: indexPath) as? BookCollectionCell

        volumes[indexPath.row].favorited = favorites.contains(volumes[indexPath.row])
        cell?.viewModel.model = volumes[indexPath.row]
        if canFetchNextPage {
            reloadNextPageOnIndexPathThreshold(indexPath, threshold: volumes.count - 1)
        }

        return cell ?? UICollectionViewCell()
    }
}
