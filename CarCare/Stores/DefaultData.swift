//
//  DefaultData.swift
//  CarCare
//
//  Created by Nick Liu on 16/3/30.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import RealmSwift

/// Add default dataDefaultData
class DefaultData {
  let realm: Realm = DBService.shareService.realm
  
  /**
   创建```Fuel```的初始数据
   */
  func createFuelData() {
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
  ///  - returns: Whether create operation success
  private func addFuel(name: String, type: FuelType) -> Bool {
    let fuelinDB = realm.objectForPrimaryKey(Fuel.self, key: name)
    if fuelinDB == nil {
      let fuel = Fuel()
      fuel.name = name
      fuel.type = type.rawValue
      try! realm.write {
        realm.add(fuel)
      }
      return true
    }
    else {
      print("Fuel already exist")
      return false
    }
  }
  
  static func create() {
    let dd = DefaultData()
    dd.createFuelData()
  }
}