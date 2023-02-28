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

class NormalNetworkExampleViewModel:NSObject,ObservableObject{
    override init() {
        super.init();
    }
    func requestExample1(){
        RequestOperationBuilder<BaseResponse>.init().baseRequest(NewRequest.init(.firstRequest(s_phone: nil))).build().responseHandler({ response in
            ResponseHandler.check(response, { baseResponse in

            })
        }).execute()
    }
    func requestExample2(){
        RequestOperationBuilder<BaseResponse>.init().baseRequest(NewRequest.init(.firstRequest(s_phone: nil))).build().executeWithCheckResponse { baseResponse in
            
        }
    }
    func requestMultipart(){
        RequestOperationBuilder<BaseResponse>.init().multipart(true).baseRequest(NewRequest.init(.multipartRequest(s_phone:nil, image:nil))).build().executeWithCheckResponse { baseResponse in
            
        }
    }
}

