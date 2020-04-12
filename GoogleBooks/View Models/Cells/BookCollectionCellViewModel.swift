//
//  BooksTableCellViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/11/20.
//

import UIKit

class BookCollectionCellViewModel {
    var model: Volume? {
        didSet {
            guard let onModelSet = onModelSet else { return }
            onModelSet()
            downloadBookThumbnail()
        }
    }

    var image: UIImage? {
        didSet {
            guard let onImageSet = onImageSet else { return }
            onImageSet()
        }
    }

    var onModelSet: (() -> Void)?

    var onImageSet: (() -> Void)?

    func downloadBookThumbnail() {
        guard let imageUrl = model?.volumeInfo.imageLinks?.thumbnail else {
            self.image = UIImage(systemName: "book.fill")
            return
        }
        GoogleBooksAPI.downloadVolumeThumbnail(url: imageUrl) { imgData, _ in
            if let data = imgData {
                self.image = UIImage(data: data)
            }
        }
    }

    func isFavorite() -> Bool {
        return model?.favorited ?? false
    }

    func onBookFavorited(indexPath: IndexPath) {
        NotificationCenter.default.post(name: BookCollectionCell.favoriteABookNotificationId, object: self, userInfo: ["indexPath": indexPath])
    }
}
