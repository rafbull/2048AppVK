//
//  Tile+CoreDataProperties.swift
//  2048AppVK
//
//  Created by Rafis on 10.04.2024.
//
//

import Foundation
import CoreData


extension Tile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tile> {
        return NSFetchRequest<Tile>(entityName: "Tile")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var value_: Int64
    @NSManaged public var positionX_: Int64
    @NSManaged public var positionY_: Int64
    @NSManaged public var newPositionX_: Int64
    @NSManaged public var newPositionY_: Int64

}

extension Tile : Identifiable {

}
