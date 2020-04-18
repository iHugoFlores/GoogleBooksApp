//
//  GoogleBooksAPI.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import Alamofire

class GoogleBooksAPI {
    // MARK: Properties
    private enum GoogleBooksAPIError: Error {
        case JSONParse
    }

    private static let pageSize: Int = 20

    typealias ServiceResponse = (VolumesQueryResponse?, Error?) -> Void
    typealias ServiceDataResponse = (Data?, Error?) -> Void

    private static let endpoint: URL = {
        var urlC = URLComponents()
        urlC.scheme = "https"
        urlC.host = "www.googleapis.com"
        urlC.path = "/books/v1/volumes"
        return urlC.url!
    }()

    // MARK: URL Query Params Builder
    private static func getQueryItemsForQueryAndPage(query: String, page: Int) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "orderBy", value: "relevance"),
            URLQueryItem(name: "startIndex", value: String(page)),
            URLQueryItem(name: "maxResults", value: String(pageSize - 2))
        ]
    }

    // MARK: Fetch Page Method
    static func getNextPageWithQuery(query: String, page: Int, onDone: @escaping ServiceResponse) {
        var urlC = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)
        urlC?.queryItems = getQueryItemsForQueryAndPage(query: query, page: page * pageSize)
        //print(urlC?.url)
        AF.request(urlC!.url!).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case let .success(data):
                guard let responseData: VolumesQueryResponse? = JSONUtil.parseDataToModel(from: data) else {
                    onDone(nil, GoogleBooksAPIError.JSONParse)
                    return
                }
                onDone(responseData, nil)
            case let .failure(error):
                onDone(nil, error)
            }
        }
    }

    // MARK: Fetch image data
    static func downloadVolumeThumbnail(url: String, onDone: @escaping ServiceDataResponse) {
        AF.request(url).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case let .success(data):
                onDone(data, nil)
            case let .failure(error):
                onDone(nil, error)
            }
        }
    }
}
