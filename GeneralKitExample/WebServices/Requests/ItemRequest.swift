//
//  ItemRequest.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ItemRequest:AppBaseRequest{
    override var baseUrl:String{
    return  "https://island-bramble.glitch.me"
    }
    public enum Route{
        case list(s_phone:String?)
    }
    private var route:Route
    init(_ route:Route) {
        self.route = route
    }
    override var path:String?{
        switch self.route{
        case .list(_):
            return "/data";
        }
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Dictionary<String,String>{
        let parameters =  super.parameters
        switch self.route{
        case .list(_):
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
        case .list(_):
            break;
        }
        let items = [ValidationObject.MultiPartObject]();
        return items
    }
}
