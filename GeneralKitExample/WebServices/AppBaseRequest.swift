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
    tempParameters["page"] = self.page
    return tempParameters
}
}
