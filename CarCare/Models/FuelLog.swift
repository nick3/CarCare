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

class Fuel: Object {
  dynamic var name = "#93"
  dynamic var type = FuelType.Petrol.rawValue
}

class FuelPrice: Object {
  dynamic var fuel = Fuel()
  dynamic var price: Float = 0.0
}

class FuelLog: Object {
  dynamic var date = NSDate()
  dynamic var fuel = Fuel()
  dynamic var price = FuelPrice()
  dynamic var distance = 0
  dynamic var fuelCapacity: Float = 0.0
  dynamic var totalPrice: Float = 0.0
  dynamic var isFull = false
}