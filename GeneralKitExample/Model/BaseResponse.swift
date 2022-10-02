//
//  BaseResponse.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class Pagination:Mappable{
    var i_per_page:NSNumber?
    var i_total_pages:NSNumber?
    var i_total_objects:NSNumber?
    var i_current_page:NSNumber?
    var i_items_on_page:NSNumber?
    
    required init?(map: ObjectMapper.Map) {
        i_per_page <- map["i_per_page"]
        i_total_pages <- map["i_total_pages"]
        i_total_objects <- map["i_total_objects"]
        i_current_page <- map["i_current_page"]
        i_items_on_page <- map["i_items_on_page"]
    }
    
    func mapping(map: ObjectMapper.Map) {
        i_per_page <- map["i_per_page"]
        i_total_pages <- map["i_total_pages"]
        i_total_objects <- map["i_total_objects"]
        i_current_page <- map["i_current_page"]
        i_items_on_page <- map["i_items_on_page"]
    }
}
class BaseResponse: BaseModel {
    var users:[User]=[User]();
    var user:User?
    var pagination:Pagination?
    open override func mapping(map: ObjectMapper.Map) {
        users <- map["users"]
        user <- map["user"]
        pagination <- map["pagination"]
    }
}
