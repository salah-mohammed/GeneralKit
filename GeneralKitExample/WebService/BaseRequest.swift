//
//  BaseRequest.swift
//  BuilderExample
//
//  Created by Mac on 6/28/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import Foundation
import Alamofire
class BaseRequest:NSObject{
    open var baseUrl:String{
        return "";
    }
    open var multiPartObjects:[ValidationObject.MultiPartObject]=[ValidationObject.MultiPartObject]();
    open var fullURL:String{
        return "\(baseUrl)\(url ?? "")"
    }
    open var header : HTTPHeaders!{
        return [:]
    }
    open var parameters:Dictionary<String,String>?{
        return nil
    } // request paramter
    open var url:String?{
        return nil;
    }  // for request path
    open var type:HTTPMethod!{
       return nil
    } // for post type : .post,.get,.delete
  
}
