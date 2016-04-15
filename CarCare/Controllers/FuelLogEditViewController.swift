//
//  FuelLogEditViewController.swift
//  CarCare
//
//  Created by Nick Liu on 16/4/14.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import RxCocoa

class FuelLogEditViewController: FormViewController {
  var viewModel: FuelLogEditViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    let saveBtn = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(save))
    navigationItem.rightBarButtonItem = saveBtn
    viewModel = FuelLogEditViewModel()
    
    form +++ Section()
      <<< DateTimeRow("CreateTimeRow") {
        $0.title = "加油时间"
      }
      <<< IntRow("DistanceRow") {
        $0.title = "里程（km）"
      }
        .cellSetup { [weak self] cell, row in
          if let this = self {
            this.textCellSetup(cell)
            this.viewModel.distance.asObservable().subscribeNext { (value) in
              row.value = value
              row.updateCell()
            }
            .addDisposableTo(this.rx_disposeBag)
          }
        }
        .onChange { [weak self] row in
          if let this = self {
            this.viewModel.distance.value = row.value
          }
        }
      <<< PushRow<Fuel>("FuelRow") { row in
        row.title = "燃料"
        row.selectorTitle = "请选择燃料类型"
      }
        .cellSetup { [weak self] cell, row in
          if let this = self {
            this.viewModel.fuel.asObservable().subscribeNext { (value) in
              row.value = value
              row.updateCell()
            }
            .addDisposableTo(this.rx_disposeBag)
          }
        }
        .onChange { [weak self] row in
          if let this = self {
            this.viewModel.fuel.value = row.value
          }
        }
      <<< DecimalRow("PriceRow") {
        $0.title = "单价（元/升）"
        let formatter = DecimalFormatter()
        formatter.currencySymbol = "￥"
        $0.useFormatterDuringInput = true
        $0.formatter = formatter
      }
        .cellSetup { [weak self] cell, row in
          if let this = self {
            this.viewModel.price.asObservable().subscribeNext { (value) in
              if let fuelPrice = value {
                row.value = Double(fuelPrice.price)
                row.updateCell()
              }
            }
            .addDisposableTo(this.rx_disposeBag)
          }
        }
        .onChange { [weak self] row in
          if let this = self {
            let fuelPrice = FuelPrice()
            if let price = row.value {
              fuelPrice.price = Float(price)
              this.viewModel.price.value = fuelPrice
            }
          }
        }
//        .cellSetup { [weak self] cell, row in
//          self?.textCellSetup(cell)
//        }
//        .onChange { [weak self] row in
//          let price = row.value != nil ? row.value! : 0.0
//          var totalPrice = 0.0
//          if let this = self {
//            if let totalPriceRow = this.form.rowByTag("TotalPriceRow") as? DecimalRow {
//              totalPrice = totalPriceRow.value != nil ? totalPriceRow.value! : 0.0
//            }
//          }
//          let fuelCapacity = price != 0.0 ? totalPrice / price : 0.0
//          if let this = self {
//            if let fuelCapacityRow = this.form.rowByTag("FuelCapacityRow") as? DecimalRow {
//              fuelCapacityRow.value = fuelCapacity
//              fuelCapacityRow.updateCell()
//            }
//          }
//        }
      <<< DecimalRow("TotalPriceRow") {
        $0.title = "总价（元）"
        let formatter = DecimalFormatter()
        formatter.currencySymbol = "￥"
        $0.useFormatterDuringInput = true
        $0.formatter = formatter
      }
        .cellSetup { [weak self] cell, row in
          if let this = self {
            this.textCellSetup(cell)
            this.viewModel.totalPrice.asObservable().subscribeNext { (value) in
              row.value = Double(value)
              row.updateCell()
            }
            .addDisposableTo(this.rx_disposeBag)
          }
        }
//        .onChange { [weak self] row in
//          if let this = self {
//            if let totalPrice = row.value {
//              this.viewModel.totalPrice.value = Float(totalPrice)
//            }
//          }
//        }
//        .cellSetup { [weak self] cell, row in
//          if let this = self {
//            this.textCellSetup(cell)
////            cell.textField.rx_text <-> this.viewModel.totalPrice
////            .addDisposableTo(this.rx_disposeBag)
//          }
//        }
//        .onChange { [weak self] row in
//          var price = 0.0
//          let totalPrice = row.value != nil ? row.value! : 0.0
//          if let this = self {
//            if let priceRow = this.form.rowByTag("PriceRow") as? DecimalRow {
//              price = priceRow.value != nil ? priceRow.value! : 0.0
//            }
//          }
//          let fuelCapacity = price != 0.0 ? totalPrice / price : 0.0
//          if let this = self {
//            if let fuelCapacityRow = this.form.rowByTag("FuelCapacityRow") as? DecimalRow {
//              fuelCapacityRow.value = fuelCapacity
//              fuelCapacityRow.updateCell()
//            }
//          }
//        }
      <<< DecimalRow("FuelCapacityRow") {
        $0.title = "加油量（升）"
      }
        .cellSetup { [weak self] cell, row in
          if let this = self {
            this.textCellSetup(cell)
            this.viewModel.fuelCapacity.asObservable().subscribeNext { (value) in
              row.value = Double(value)
              row.updateCell()
              }
              .addDisposableTo(this.rx_disposeBag)
          }
        }
//        .onChange { [weak self] row in
//          if let this = self {
//            if let fuelCapacity = row.value {
//              this.viewModel.fuelCapacity.value = Float(fuelCapacity)
//            }
//          }
//        }
//        .cellSetup { [weak self] cell, row in
//          self?.textCellSetup(cell)
//        }
//        .onChange { [weak self] row in
//          let fuelCapacity = row.value != nil ? row.value! : 0.0
//          var price = 0.0
//          if let this = self {
//            if let priceRow = this.form.rowByTag("PriceRow") as? DecimalRow {
//              price = priceRow.value != nil ? priceRow.value! : 0.0
//            }
//          }
//          let totalPrice = price * fuelCapacity
//          if let this = self {
//            if let totalPriceRow = this.form.rowByTag("TotalPriceRow") as? DecimalRow {
//              totalPriceRow.value = totalPrice
//              totalPriceRow.updateCell()
//            }
//          }
//        }
      <<< SwitchRow("IsFullRow") {
        $0.title = "已加满"
      }
        .cellSetup { [weak self] cell, row in
          if let this = self {
            this.viewModel.isFull.asObservable().subscribeNext { (value) in
              row.value = value
              row.updateCell()
            }
            .addDisposableTo(this.rx_disposeBag)
          }
        }
//        .onChange { [weak self] row in
//          if let this = self {
//            if let isFull = row.value {
//              this.viewModel.isFull.value = isFull
//            }
//          }
//        }
    
    initOptionsBinding()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func initOptionsBinding() {
    viewModel.fuelRowOptions.subscribeNext { [weak self] (fuels) in
      if let this = self {
        if let fuelRow = this.form.rowByTag("FuelRow") as? PushRow<Fuel> {
          fuelRow.options = fuels
          fuelRow.updateCell()
        }
      }
    }
    .addDisposableTo(rx_disposeBag)
  }
  
  func textCellSetup(cell: TextFieldCell)  {
    cell.textField.rx_controlEvent(.EditingDidBegin)
    .subscribeNext {
      cell.textField.selectAll(cell.textField)
    }
    .addDisposableTo(rx_disposeBag)
  }
  
  func save() {
    let values = self.form.values()
    let fuelLog = FuelLog()
    if let value = values["CreateTimeRow"] as? NSDate {
      fuelLog.date = value
    }
    if let value = values["DistanceRow"] as? Int {
      fuelLog.distance = value
    }
    if let value = values["FuelRow"] as? Fuel {
      fuelLog.fuel = value
    }
    if let value = values["PriceRow"] as? Float {
      let price = FuelPrice()
      price.fuel = fuelLog.fuel
      price.price = value
      price.date = fuelLog.date
      fuelLog.price = price
    }
    if let value = values["TotalPriceRow"] as? Float {
      fuelLog.totalPrice = value
    }
    if let value = values["FuelCapacityRow"] as? Float {
      fuelLog.fuelCapacity = value
    }
    if let value = values["IsFullRow"] as? Bool {
      fuelLog.isFull = value
    }
    print(viewModel.distance.value)
    
//    try
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
