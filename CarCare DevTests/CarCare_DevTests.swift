//
//  CarCare_DevTests.swift
//  CarCare DevTests
//
//  Created by Nick Liu on 16/3/30.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import XCTest
import RxSwift
import NSObject_Rx

@testable import CarCare_Dev

class CarCare_DevTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFuelLogModelView() {
      let flViewModel = FuelLogsViewModel()
      let fuelLogs = flViewModel.fuelLogs
      fuelLogs.subscribe { event in
        print("2->\(event)")
      }
      .addDisposableTo(rx_disposeBag)
      flViewModel.loadFromDB()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
