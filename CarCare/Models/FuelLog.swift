//
//  FuelLog.swift
//  CarCare
//
//  Created by Nick Liu on 16/3/29.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import Foundation
import RealmSwift

enum FuelType: Int8 {
  case Petrol = 1, Diesel, Electric, Hydrogen
}

class Fuel: Object, Equatable {
  dynamic var name = "#93"
  dynamic var type = FuelType.Petrol.rawValue
  
  override static func primaryKey() -> String {
    return "name"
  }
  
  override var description: String {
    var typeDesc: String = ""
    if let type = FuelType(rawValue: self.type) {
      switch type {
      case .Petrol:
        typeDesc = "汽油"
      case .Diesel:
        typeDesc = "柴油"
      case .Electric:
        typeDesc = "电力"
      case .Hydrogen:
        typeDesc = "氢燃料"
      }
    }
    return "\(name) \(typeDesc)"
  }
}

func ==(lhs: Fuel, rhs: Fuel) -> Bool {
  if lhs.name == rhs.name && lhs.type == rhs.type {
    return true
  }
  else {
    return false
  }
}

class FuelPrice: Object {
  dynamic var id = NSUUID().UUIDString
  dynamic var fuel: Fuel? = nil
  dynamic var price: Float = 0.0
  dynamic var date = NSDate()
  
  override static func primaryKey() -> String {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["id"]
  }
}

class FuelLog: Object {
  dynamic var id = NSUUID().UUIDString
  dynamic var date = NSDate()
  dynamic var fuel: Fuel? = nil
  dynamic var price: FuelPrice? = nil
  dynamic var distance = 0
  dynamic var fuelCapacity: Float = 0.0
  dynamic var totalPrice: Float = 0.0
  dynamic var isFull = false
  
  override static func primaryKey() -> String {
    return "id"
  }
}