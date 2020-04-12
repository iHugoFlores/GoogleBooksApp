//
//  VolumeCD+CoreDataProperties.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/12/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//
//

import Foundation
import CoreData

extension VolumeCD {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VolumeCD> {
        return NSFetchRequest<VolumeCD>(entityName: "VolumeCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var favorited: Bool
    @NSManaged public var title: String?
    @NSManaged public var authors: NSObject?
    @NSManaged public var thumbnail: String?
}
