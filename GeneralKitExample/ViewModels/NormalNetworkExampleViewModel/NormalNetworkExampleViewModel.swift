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
//        let group = RequestBuilderGroup<BaseResponse>.init(nil)
//
//        let firstRequest = RequestOperationBuilder<BaseResponse>.init()
//            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
//
//        let firstProcess:RequestBuilderGroup<BaseResponse>.Process = (firstRequest,{ a in
//
//        })
//        let secondRequest = RequestOperationBuilder<BaseResponse>.init()
//            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
//
//        let secondProcess:RequestBuilderGroup<BaseResponse>.Process = (secondRequest,{ a in
//
//        })
//        group.append(firstProcess).append(secondProcess)
//        group.build().execute()
    }
    func requestExample1(){
        RequestOperationBuilder<BaseResponse>.init()
            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build()
            .responseHandler({ response in
            ResponseHandler.check(response, { baseResponse in

            })
        }).execute()
    }
    func requestExample2(){
        RequestOperationBuilder<BaseResponse>.init()
            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build()
            .executeWithCheckResponse { baseResponse in
            
        }
    }
    func requestExample3(){
        RequestOperationBuilder<BaseResponse>.init()
            .encoding(JSONEncoding.default)
            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build().executeWithCheckResponse { baseResponse in
            
        }
    }
    func requestMultipart(){
        RequestOperationBuilder<BaseResponse>.init()
            .multipart(true)
            .baseRequest(NewRequest.init(.multipartRequest(s_phone:nil, image:nil)))
            .build()
            .executeWithCheckResponse { baseResponse in
            
        }
    }
}

