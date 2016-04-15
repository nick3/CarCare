//
//  RxHelper.swift
//  CarCare
//
//  Created by Nick Liu on 16/4/15.
//  Copyright © 2016年 Nick Liu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Eureka

// Two way binding operator between control property and variable, that's all it takes {

infix operator <-> {
}

func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
  let bindToUIDisposable = variable.asObservable()
    .bindTo(property)
  let bindToVariable = property
    .subscribe(onNext: { n in
      variable.value = n
      }, onCompleted:  {
        bindToUIDisposable.dispose()
    })
  
  return StableCompositeDisposable.create(bindToUIDisposable, bindToVariable)
}