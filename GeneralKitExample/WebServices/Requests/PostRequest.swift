//
//  PostRequest.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class PostRequest:AppBaseRequest{
    override var baseUrl:String{
    return  "https://jsonplaceholder.typicode.com"
    }
    public enum Route{
        case list
    }
    private var route:Route
    init(_ route:Route) {
        self.route = route
    }
    override var path:String?{
        switch self.route{
        case .list:
            return "/posts";
        }
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Parameters{
        var parameters =  super.parameters
        switch self.route{
        case .list:
            parameters["_limit"]=10
            parameters["_start"]=self.offset

            break;
        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
        switch self.route{
        case .list:
            return .get
        }
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
        switch self.route{
        case .list:
            break;
        }
        let items = [ValidationObject.MultiPartObject]();
        return items
    }
}
