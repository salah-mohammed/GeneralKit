//
//  User.swift
//  GeneralKitExample
//
//  Created by Salah on 10/2/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class User:Mappable{
    var id:NSNumber?
    var username:String?
    var fullname:String?
    required init?(map: ObjectMapper.Map) {
        id <- map["id"]
        username <- map["username"]
        fullname <- map["fullname"]
    }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        username <- map["username"]
        fullname <- map["fullname"]
    }
    
    
}
