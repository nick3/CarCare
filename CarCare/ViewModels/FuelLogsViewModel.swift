//
//  FuelLogViewModel.swift
//  CarCare
//
//  Created by Nick Liu on 16/4/1.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import GCDKit

class FuelLogsViewModel {
//  var fuelLogs = BehaviorSubject(value: [FuelLogCellViewModel]())
  let pageLimit = 50
  
  func fetchFuelLogs(fromPage page: Int) -> Observable<[FuelLogCellViewModel]> {
    return Observable.create { (observer) -> Disposable in
      var fuelLogsArray: [FuelLogCellViewModel] = []
      GCDBlock.async(.Background) {
        let realm = try! Realm()
        let result = realm.objects(FuelLog).sorted("date", ascending: false)
        let count = result.count
        for i in (page * self.pageLimit)..<self.pageLimit {
          if i < count {
            let fuelLog = result[i]
            fuelLogsArray.append(FuelLogCellViewModel(fuelLog: fuelLog))
          }
          else {
            break
          }
        }
      }
      .notify(.Main) {
        observer.on(.Next(fuelLogsArray))
        observer.on(.Completed)
      }
      return NopDisposable.instance
    }
  }
}