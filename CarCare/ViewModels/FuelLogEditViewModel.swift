//
//  FuelLogEditViewModel.swift
//  CarCare
//
//  Created by Nick Liu on 16/4/14.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import GCDKit

class FuelLogEditViewModel {
  func fetchFuel() -> Observable<[Fuel]> {
    return Observable.create { (observer) -> Disposable in
      var result: Results<(Fuel)>?
      GCDBlock.async(.Background) {
        let realm = try! Realm()
        result = realm.objects(Fuel).sorted("type")
      }
      .notify(.Main) { [weak result] in
        if let fuels = result {
          observer.on(.Next(fuels.flatMap { (fuel) -> Fuel in
            return fuel
          }))
          observer.on(.Completed)
        }
      }
      return NopDisposable.instance
    }
  }
}