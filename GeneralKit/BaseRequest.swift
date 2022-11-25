//
//  BaseRequest.swift
//  BuilderExample
//
//  Created by Mac on 6/28/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import Foundation
import Alamofire
open class BaseRequest:NSObject{
    public var page : String?
    public var peerPage : String?
    
    var fullURL:String{
        return "\(baseUrl)\(path ?? "")"
    }
    // need data
   open var baseUrl:String{
        return  ""
    }
    open var path:String?{
        return nil;
    }  // for request path
    open var header : HTTPHeaders?{
        return nil
    }
    open  var token:String?{
        return nil;
    }
    open var parameters:Dictionary<String,String>{
      var tempParameters =  Dictionary<String,String>()
        return tempParameters
    } // request paramter
    open  var type:HTTPMethod!{
       return nil
    } // for post type : .post,.get,.delete
    open  var multiPartObjects : [ValidationObject.MultiPartObject]{
        return [ValidationObject.MultiPartObject]()
    }
}
