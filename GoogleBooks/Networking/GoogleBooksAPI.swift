//
//  GoogleBooksAPI.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import Alamofire

class GoogleBooksAPI {
    private static let pageSize: Int = 20
    
    private static let endpoint: URL = {
        var urlC = URLComponents()
        urlC.scheme = "https"
        urlC.host = "www.googleapis.com"
        urlC.path = "/books/v1/volumes"
        return urlC.url!
    }()
    
    private static func getQueryItemsForQueryAndPage(query: String, page: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "startIndex", value: String(page)),
            URLQueryItem(name: "maxResults", value: String(pageSize))
        ]
    }

    static func getNextPageWithQuery(query: String, page: Int) {
        var urlC = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)
        urlC?.queryItems = getQueryItemsForQueryAndPage(query: query, page: page)
        AF.request(urlC!.url!).responseJSON { data in
            print("Call ended. Data: \(data)")
        }
    }
}
