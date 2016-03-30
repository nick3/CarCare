//
//  DBHelper.swift
//  CarCare
//
//  Created by Nick Liu on 16/3/30.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import Foundation
import RealmSwift

class DBService {
  static let shareService = DBService()
  
  let realm: Realm
  
  private init() {
    let config = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: { (migration, oldSchemaVersion) in
        if oldSchemaVersion < 1 {
          // Nothing to do!
        }
    })
    Realm.Configuration.defaultConfiguration = config
    realm = try! Realm()
  }
}