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
            self.image = UIImage(systemName: "photo")
            return
        }
        GoogleBooksAPI.downloadVolumeThumbnail(url: imageUrl) { imgData, error in
            if let data = imgData {
                self.image = UIImage(data: data)
            }
        }
    }
}
