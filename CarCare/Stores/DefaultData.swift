//
//  DefaultData.swift
//  CarCare
//
//  Created by Nick Liu on 16/3/30.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import RealmSwift
import RxSwift
import RxRealm

/// Add default data
struct DefaultData {
  static func initialize() {
    addFuel("#93", type: .Petrol)
    addFuel("#97", type: .Petrol)
    addFuel("#98", type: .Petrol)
    addFuel("#92", type: .Petrol)
    addFuel("#95", type: .Petrol)
    addFuel("#0", type: .Diesel)
  }
  
  ///  Add a new ```Fuel``` data
  ///
  ///  - parameter name: Fuel name
  ///  - parameter type: Fuel type
  ///
  ///  - returns: Added fuel data
  static func addFuel(name: String, type: FuelType) -> Fuel {
    let fuel = Fuel()
    fuel.name = name
    fuel.type = type.rawValue
    Realm.rx_create(fuel, value: fuel)
    return fuel
  }
}