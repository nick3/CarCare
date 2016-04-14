//
//  FuelLogCellViewModel.swift
//  CarCare
//
//  Created by Nick Liu on 16/4/14.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import Foundation

class FuelLogCellViewModel {
  private var _fuelLog: FuelLog?
  var fuelLog: FuelLog? {
    get {
      return _fuelLog
    }
    set {
      _fuelLog = newValue
      if let fuelLog = newValue {
        if let price = fuelLog.price {
          priceString = "\(price.price) 元/L"
        }
        else {
          priceString = "未记录的单价"
        }
        distanceString = "\(fuelLog.distance) km"
        totalPriceString = "\(fuelLog.totalPrice) 元"
      }
      else {
        priceString = "未记录的单价"
        distanceString = "未记录的里程"
        totalPriceString = "未记录的总价"
      }
    }
  }
  
  var priceString: String?
  var distanceString: String?
  var totalPriceString: String?
  
  init(fuelLog: FuelLog) {
    self.fuelLog = fuelLog
  }

}
