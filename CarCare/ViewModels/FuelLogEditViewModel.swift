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
import Eureka
import NSObject_Rx

class FuelLogEditViewModel: NSObject {
  var date = Variable(NSDate())
  var distance: Variable<Int?> = Variable(0)
  var fuel = Variable<Fuel?>(nil)
  var price = Variable<FuelPrice?>(nil)
  var totalPrice = Variable<Float>(0.0)
  var fuelCapacity = Variable<Float>(0.0)
  var isFull = Variable<Bool>(false)
  
  var fuelRowOptions = BehaviorSubject<[Fuel]>(value: [])
  
  init(currentFuelLog: FuelLog? = nil) {
    super.init()
    fetchFuel().bindTo(fuelRowOptions).addDisposableTo(rx_disposeBag)
    
    if let fuelLog = currentFuelLog {
      date.value = fuelLog.date
      distance.value = fuelLog.distance
      fuel.value = fuelLog.fuel
      price.value = fuelLog.price
      totalPrice.value = fuelLog.totalPrice
      fuelCapacity.value = fuelLog.fuelCapacity
      isFull.value = fuelLog.isFull
    }
    else {
      let price = FuelPrice()
      price.price = 0.0
      self.price.value = price
      fetchLastPrice().subscribeNext { [weak self] fuelPrice in
        self?.price.value = fuelPrice
      }
      .addDisposableTo(rx_disposeBag)
      
      fuelRowOptions.subscribeNext { [weak self] fuels in
        if fuels.count > 0 {
          self?.fuel.value = fuels.first!
        }
      }
      .addDisposableTo(rx_disposeBag)
    }
    
    price.asObservable().distinctUntilChanged { lhs, rhs -> Bool in
      if let left = lhs, right = rhs {
        if left.price != right.price {
          return false
        }
      }
      return true
    }
    .subscribeNext { [weak self] fuelPrice in
      if let this = self {
        let price = fuelPrice?.price
        let capacity = (price != nil && price! != 0.0) ? this.totalPrice.value / price! : 0.0
        this.fuelCapacity.value = capacity
      }
    }
    .addDisposableTo(rx_disposeBag)
    totalPrice.asObservable().distinctUntilChanged().subscribeNext { [weak self] totalPrice in
      if let this = self {
        let price = this.price.value?.price
        let capacity = (price != nil && price! != 0.0) ? totalPrice / price! : 0.0
        this.fuelCapacity.value = capacity
      }
    }
    .addDisposableTo(rx_disposeBag)
    
    fuelCapacity.asObservable().distinctUntilChanged().subscribeNext { [weak self] capacity in
      if let this = self {
        let price = this.price.value?.price
        let totalPrice = price != nil ? price! * capacity : 0.0
        this.totalPrice.value = totalPrice
      }
    }
    .addDisposableTo(rx_disposeBag)
  }
  
  func fetchFuel() -> Observable<[Fuel]> {
    return Observable.create { observer -> Disposable in
      var fuels: [Fuel] = []
      let realm = try! Realm()
      let result = realm.objects(Fuel).sorted("type")
      for fuel in result {
        fuels.append(fuel)
      }
      observer.on(.Next(fuels))
      observer.on(.Completed)
      return NopDisposable.instance
    }
  }
  
  func fetchLastPrice() -> Observable<FuelPrice> {
    return Observable.create { observer -> Disposable in
      let realm = try! Realm()
      let result = realm.objects(FuelPrice).sorted("date", ascending: false)
      if result.count > 0 {
        let fuelPrice = result.first!
        observer.onNext(fuelPrice)
      }
      observer.onCompleted()
      return NopDisposable.instance
    }
  }
}