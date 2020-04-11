//
//  JSONUtil.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/11/20.
//

import Foundation

class JSONUtil {
    static func parseDataToModel<T>(from data: Data) -> T? where T: Codable {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
