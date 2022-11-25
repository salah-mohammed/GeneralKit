//
//  File.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class LoginViewModel:NSObject,ObservableObject{
    override init() {
        super.init();
    }
    func loginRequest(){
        RequestOperationBuilder<BaseResponse>.init().baseRequest(NewRequest.init(.firstRequest(s_phone: nil))).build().responseHandler({ response in

        }).execute()
    }
}

