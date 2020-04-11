//
//  VolumesQueryResponse.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import Foundation

struct VolumesQueryResponse {
    let kind: String
    let totalItems: Int
    let items: [Volume]
}
