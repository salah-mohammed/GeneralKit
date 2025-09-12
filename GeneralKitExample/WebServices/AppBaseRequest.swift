//
//  AppBaseRequest.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class AppBaseRequest:BaseRequest{
    override var baseUrl:String{
        return  "https://raw.githubusercontent.com"
    }
    override var token:String?{
        return nil;
    }
    override var parameters:Parameters{
        var tempParameters =  super.parameters;
        
        if let page:String = self.page{
            // MARK: - PaginationResponseHandler if api base on page number
            tempParameters["page"] = page
        }else
        if let offset:Int = self.offset {
            // MARK: - PaginationResponseHandler if api base on offset
            tempParameters["limit"]=self.limit
            tempParameters["offset"]=offset
        }
        return tempParameters
    }
    
    override init() {
        super.init()
        self.limit = 10
    }
}
