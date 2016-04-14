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

    viewModel = FuelLogEditViewModel()
    // Do any additional setup after loading the view.
    form +++ Section()
      <<< DateTimeRow("CreateTimeRow") {
        $0.title = "加油时间"
        $0.value = NSDate()
      }
      <<< DecimalRow("DistanceRow") {
        $0.title = "里程"
      }
        .cellSetup { [weak self] cell, row in
          self?.textCellSetup(cell)
        }
      <<< PickerRow<Fuel>("FuelRow") { row in
        row.title = "燃料"
        viewModel.fetchFuel().subscribeNext { (fuels) in
          row.options = []
          for fuel in fuels {
            row.options.append("a")
          }
        }
        .addDisposableTo(rx_disposeBag)
      }
      <<< DecimalRow("PriceRow") {
        $0.title = "单价"
      }
        .cellSetup { [weak self] cell, row in
          self?.textCellSetup(cell)
        }
        .onChange { [weak self] row in
          let price = row.value != nil ? row.value! : 0.0
          var totalPrice = 0.0
          if let this = self {
            if let totalPriceRow = this.form.rowByTag("TotalPriceRow") as? DecimalRow {
              totalPrice = totalPriceRow.value != nil ? totalPriceRow.value! : 0.0
            }
          }
          let fuelCapacity = price != 0.0 ? totalPrice / price : 0.0
          if let this = self {
            if let fuelCapacityRow = this.form.rowByTag("FuelCapacityRow") as? DecimalRow {
              fuelCapacityRow.value = fuelCapacity
              fuelCapacityRow.updateCell()
            }
          }
        }
      <<< DecimalRow("TotalPriceRow") {
        $0.title = "总价"
      }
        .cellSetup { [weak self] cell, row in
          self?.textCellSetup(cell)
        }
        .onChange { [weak self] row in
          var price = 0.0
          let totalPrice = row.value != nil ? row.value! : 0.0
          if let this = self {
            if let priceRow = this.form.rowByTag("PriceRow") as? DecimalRow {
              price = priceRow.value != nil ? priceRow.value! : 0.0
            }
          }
          let fuelCapacity = price != 0.0 ? totalPrice / price : 0.0
          if let this = self {
            if let fuelCapacityRow = this.form.rowByTag("FuelCapacityRow") as? DecimalRow {
              fuelCapacityRow.value = fuelCapacity
              fuelCapacityRow.updateCell()
            }
          }
        }
      <<< DecimalRow("FuelCapacityRow") {
        $0.title = "加油量"
      }
        .cellSetup { [weak self] cell, row in
          self?.textCellSetup(cell)
        }
        .onChange { [weak self] row in
          let fuelCapacity = row.value != nil ? row.value! : 0.0
          var price = 0.0
          if let this = self {
            if let priceRow = this.form.rowByTag("PriceRow") as? DecimalRow {
              price = priceRow.value != nil ? priceRow.value! : 0.0
            }
          }
          let totalPrice = price * fuelCapacity
          if let this = self {
            if let totalPriceRow = this.form.rowByTag("TotalPriceRow") as? DecimalRow {
              totalPriceRow.value = totalPrice
              totalPriceRow.updateCell()
            }
          }
        }
      <<< SwitchRow("IsFullRow") {
        $0.title = "已加满"
        $0.value = false
      }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textCellSetup(cell: TextFieldCell)  {
    cell.textField.rx_controlEvent(.EditingDidBegin)
    .subscribeNext {
      cell.textField.selectAll(cell.textField)
    }
    .addDisposableTo(rx_disposeBag)
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
