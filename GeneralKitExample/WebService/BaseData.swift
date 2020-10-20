//
//  BaseData.swift
//  EnnnerVoice
//
//  Created by Salah on 7/27/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
extension BaseData {
    func hasNextPage(currentPage:Int?)->Bool{
        if currentPage == nil {
            return false;
        }
        if (self.next_page_url != nil )
        {
            
            return true;
        }
        return false
    }
    func hasPreviousPage(currentPage:Int?)->Bool{
        if currentPage == nil {
            return false;
        }
        if (self.prev_page_url != nil){
            return true;
        }
        return false
    }
}

class BaseData: NSObject,Mappable {
    @objc  var current_page:Int=1;
    @objc  var first_page_url:String?;
    @objc  var from:Int=0;
    @objc  var last_page:Int=0;
    @objc  var last_page_url:String?;
    @objc  var next_page_url:String?;
    @objc  var per_page:Int=0;
    @objc  var prev_page_url:String?;
    @objc  var to:Int=0;
    @objc  var total:Int=0;
//    @objc  var options:OptionsObject?

    

    
//    var jobsList:[Job] = [Job]();
//    var ticketList:[Ticket] = [Ticket]();
//    var usersList:List<UserRealm> = List<UserRealm>()


    required init?(map: Map) {
        current_page    <- map["current_page"]
        first_page_url    <- map["first_page_url"]
        from    <- map["from"]
        last_page    <- map["last_page"]
        last_page_url    <- map["last_page_url"]
        next_page_url    <- map["next_page_url"]
        per_page    <- map["per_page"]
        total    <- map["total"]
        to    <- map["to"]
        prev_page_url    <- map["prev_page_url"]
        per_page    <- map["per_page"]
//        jobsList    <- map["items"]
//        ticketList    <- map["items"]
//        usersList    <- (map["items"],ListTransform<UserRealm>())
//        options    <- map["options"]



    }
    
    func mapping(map: Map) {
        current_page    <- map["current_page"]
        first_page_url    <- map["first_page_url"]
        from    <- map["from"]
        last_page    <- map["last_page"]
        last_page_url    <- map["last_page_url"]
        next_page_url    <- map["next_page_url"]
        per_page    <- map["per_page"]
        total    <- map["total"]
        to    <- map["to"]
        prev_page_url    <- map["prev_page_url"]
        per_page    <- map["per_page"]
        current_page    <- map["current_page"]
        first_page_url    <- map["first_page_url"]
        from    <- map["from"]
        last_page    <- map["last_page"]
        last_page_url    <- map["last_page_url"]
        next_page_url    <- map["next_page_url"]
        per_page    <- map["per_page"]
        total    <- map["total"]
        to    <- map["to"]
        prev_page_url    <- map["prev_page_url"]
        per_page    <- map["per_page"]
//        jobsList    <- map["items"]
//        ticketList    <- map["items"]
//        usersList    <- (map["items"],ListTransform<UserRealm>())
//        options    <- map["options"]

    }
    
    


}
