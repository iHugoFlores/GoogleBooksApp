//
//  BookDetailsViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import Foundation

class BookDetailsViewModel {
    var model: Volume? {
        didSet {
            guard let onModelSet = onModelSet else { return }
            onModelSet()
        }
    }

    var onModelSet: (() -> Void)?
}
