//
//  UserRequest.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class UserRequest:BaseRequest{
    override var baseUrl:String{
    return  "https://salahmohamed.website/ClassGeneratorPro/"
    }
    open override var localJsonURL:String?{
        switch self.route{
        case .users_simulateRemoteResponse:
            return  Bundle.main.path(forResource:"usersList\(page ?? "")", ofType:"json")
        default:
            return  nil
        }
    }
    public enum Route{
        case users_simulateRemoteResponse
        case users
        case login
        case profile(image:Data?=nil)
    }
    private var route:Route
    init(_ route:Route) {
        self.route = route
    }
    override var path:String?{
        switch self.route{
        case .users_simulateRemoteResponse:
            return "usersList\(self.page ?? "1").json";
        case .users:
            return "usersList\(self.page ?? "1").json";
        case .login:
            return "login"
        case .profile(image: let image):
            return "profile"
        }
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Parameters{
        let parameters =  super.parameters
        switch self.route{
        case .users_simulateRemoteResponse:
            break;
        case .users:
            break;
        case .login:
            break;
        case .profile:
            break;
        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
        switch self.route{
        case .profile,.login:
            return .post
        case .users,.users_simulateRemoteResponse:
            return .get
        }
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
        var items = [ValidationObject.MultiPartObject]();
        switch self.route{
        case .users,.login,.users_simulateRemoteResponse:
            return items
        case .profile(image:let imageData):
            if let imageData:Data = imageData{
                let multiPartObject = ValidationObject.MultiPartObject.init(data:imageData, name:"photo", fileName:"file.png", mimeType: "image/*");
                items.append(multiPartObject)
            }
            return items
        }
    }
}
