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
    // MARK: - PaginationResponseHandler if api base on page number
    var pagination:Pagination?
    // MARK: - PaginationResponseHandler if api base on offset
    var metadata: Metadata?

    open override func mapping(map: ObjectMapper.Map) {
        users <- map["users"]
        user <- map["user"]
        pagination <- map["pagination"]
        metadata <- map["metadata"]

    }
}

class Metadata: Mappable {
    var resultset: ResultSet?

    required init?(map: Map) {
        resultset <- map["resultset"]
    }

    func mapping(map: Map) {
        resultset <- map["resultset"]
    }
}

class ResultSet: Mappable {
    var count: Int?
    var limit: Int?
    var offset: Int?

    required init?(map: Map) {
        count <- map["count"]
        limit <- map["limit"]
        offset <- map["offset"]
    }

    func mapping(map: Map) {
        count <- map["count"]
        limit <- map["limit"]
        offset <- map["offset"]
    }
}
