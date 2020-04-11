//
//  BooksTableViewModel.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import Foundation

class BooksTableViewModel {
    var lastPage = 0
    var query = ""
    var volumes: [Volume] = []

    typealias ServiceResponse = (Volume?, Error?) -> Void

    func searchNewQuery() {
        GoogleBooksAPI.getNextPageWithQuery(query: query, page: lastPage)
    }

    func getNextPage(onDone: ServiceResponse) {
    }
}
