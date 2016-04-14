//
//  FuelLogViewController.swift
//  CarCare
//
//  Created by Nick Liu on 16/4/14.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import UIKit
import GearRefreshControl
import RxSwift
import NSObject_Rx

class FuelLogViewController: UITableViewController {
  var gearRefreshControl: GearRefreshControl!
  var viewModel: FuelLogsViewModel!
  var page: Variable<Int> = Variable(0)

  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    // 刷新组件初始化
    gearRefreshControl = GearRefreshControl(frame: view.bounds)
    gearRefreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
    
    viewModel = FuelLogsViewModel()
    initPager()
  }
  
  func initPager() {
    page.asObservable().throttle(0.5, scheduler: MainScheduler.instance)
    .doOn { [unowned self] value in
      self.gearRefreshControl.enabled = false
    }
    .flatMap { [unowned self] in
      self.viewModel.fetchFuelLogs(fromPage: $0)
      .doOn { [unowned self] in
        self.gearRefreshControl.endRefreshing()
        self.gearRefreshControl.enabled = true
      }
      .retry()
      .catchErrorJustReturn([])
    }
    
    .subscribeNext { (fuelLogs) in
      print(fuelLogs.count)
    }
    .addDisposableTo(rx_disposeBag)
  }
  
  func refresh() {
    page.value = 0
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
  }

  /*
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

      // Configure the cell...

      return cell
  }
  */

  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
