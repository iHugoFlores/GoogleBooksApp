//
//  VolumesQueryResponse.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import Foundation

struct VolumesQueryResponse: Codable {
    let kind: String
    let totalItems: Int
    let items: [Volume]?
}
