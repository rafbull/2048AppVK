//
//  Tile+CoreDataClass.swift
//  2048AppVK
//
//  Created by Rafis on 10.04.2024.
//
//

import Foundation
import CoreData

@objc(Tile)
public class Tile: NSManagedObject {
    var value: Int {
        get { return Int(value_) }
        set { value_ = Int64(newValue) }
    }
    
    var positionX: Int {
        get { return Int(positionX_) }
        set { positionX_ = Int64(newValue) }
    }
    
    var positionY: Int {
        get { return Int(positionY_) }
        set { positionY_ = Int64(newValue) }
    }
    
    var newPositionX: Int {
        get { return Int(newPositionX_) }
        set { newPositionX_ = Int64(newValue) }
    }
    
    var newPositionY: Int {
        get { return Int(newPositionY_) }
        set { newPositionY_ = Int64(newValue) }
    }
}
