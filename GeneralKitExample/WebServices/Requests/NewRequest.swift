//
//  NewRequest.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class NewRequest:AppBaseRequest{
    public enum Route{
        case firstRequest(s_phone:String?)
        case secondRequest(s_phone:String?)
    }
    private var route:Route
    init(_ route:Route) {
        self.route = route
    }
    override var path:String?{
        switch self.route{
        case .firstRequest(_):
            break;
        case .secondRequest(_):
            break;
        }
        return "/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json";
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Dictionary<String,String>{
       var parameters =  super.parameters
//        switch self.route{
//        case .firstRequest(_):
//            break;
//        case .secondRequest(_):
//            break;
//        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
//        switch self.route{
//        case .firstRequest(_):
//            break;
//        case .secondRequest(_):
//            break;
//        }
        return .get
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
//        switch self.route{
//        case .firstRequest(_):
//            break;
//        case .secondRequest(_):
//            break;
//        }
        let items = [ValidationObject.MultiPartObject]();
        return items
    }
}
