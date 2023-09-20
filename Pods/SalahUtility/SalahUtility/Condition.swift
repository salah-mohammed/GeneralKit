//
//  Condition.swift
//  SalahUtility
//
//  Created by SalahMohamed on 30/03/2023.
//  Copyright © 2023 Salah. All rights reserved.
//

import Foundation

public protocol ConditionProtocol{
    /* if result of check == false check fail if check == true the check is success  */
    var check:Bool{get}
    /* The goal of operation function when failure action accure will implemented or this depend on your condition*/
    func operation()->Bool
    var subConditions:[ConditionProtocol]{get}
}
public extension ConditionProtocol{
    func checkWithOperation()->Bool{
    let check = self.check
    if check{
    return self.operation()
    }
    return check
    }
}
public extension Array where Element == ConditionProtocol {
   @discardableResult func checkWithOperation()->Bool{
        for item in self{
            var isChecked = item.checkWithOperation()
            if let first:ConditionProtocol = item.subConditions.first(where:{$0.check == false}){
                isChecked = first.operation();
            }
            if isChecked == false{
                return isChecked
            }
        }
     return true
    }
    @discardableResult func check()->Bool{
         for item in self{
             var isChecked = item.check
             if let first:ConditionProtocol = item.subConditions.first(where:{$0.check == false}){
                 isChecked = first.check
             }
             if isChecked == false{
                 return isChecked
             }
         }
      return true
     }
}
