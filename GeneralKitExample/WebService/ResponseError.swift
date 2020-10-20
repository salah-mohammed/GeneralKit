//
//  Error.swift
//  EnnnerVoice
//
//  Created by Salah on 7/28/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import UIKit
import ObjectMapper
@objc(ResponseError)
class ResponseError: NSObject,Mappable {
    @objc var status:Int=0
    @objc var name:String?
    @objc var bs_description:String?
    @objc var details:[String]?
    
    

    
    required init?(map: Map){
        status    <- map["status"]
        name    <- map["name"]
        bs_description    <- map["description"]
        details    <- map["details"]
        
    }
    
    func mapping(map: Map) {
        status    <- map["status"]
        name    <- map["name"]
        bs_description    <- map["description"]
        details    <- map["details"]

        
    }
}

