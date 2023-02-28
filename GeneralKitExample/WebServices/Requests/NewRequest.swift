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
        case multipartRequest(s_phone:String?,image:Data?)
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
        case .multipartRequest(s_phone: let s_phone, image: let image):
            break;
        }
        return "/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json";
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Parameters{
       var parameters =  super.parameters
        switch self.route{
        case .firstRequest(_):
            break;
        case .secondRequest(_):
            break;
        case .multipartRequest(s_phone: let s_phone, image: _):
            parameters["s_phone"]=s_phone
            break;
        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
        switch self.route{
        case .secondRequest(_),.firstRequest(_):
            return .get
        case .multipartRequest(s_phone: _, image: _):
            return .post
        }
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
        var items = [ValidationObject.MultiPartObject]();
        switch self.route{
        case .firstRequest(_),.secondRequest(_):
            break;
        case .multipartRequest(s_phone:let _, image: let image):
            if let image:Data=image{
                items.append(ValidationObject.MultiPartObject(data:image,name:"",fileName:"",mimeType:""))
            }
            break
        }
        return items
    }
}
