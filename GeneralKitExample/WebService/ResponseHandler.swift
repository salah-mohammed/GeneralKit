//
//  ResponseHandler.swift
//  Jobs
//
//  Created by Salah on 1/11/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
class ResponseHandler {
    static func responseHandler(result:SessionManager.MultipartFormDataEncodingResult,enableErrorMessage:Bool,enableWaitingView:Bool,enableUnAuthorizedExit:Bool,objectDebug:CustomDebugStringConvertible?,restrictSuccessHandler:RequestOperationBuilder.RestrictSuccessHandler?,restrictErrorHandler:RequestOperationBuilder.RestrictErrorHandler?,dataResponse:@escaping (DataResponse<BaseResponse>) -> Void){
        switch result {
        case .success(let request, let streamingFromDisk, let streamFileURL):
            request.responseObject { (response : DataResponse<BaseResponse>) in
                dataResponse(response);
                ResponseHandler.responseHandler(baseResponse:response, enableWaitingView: enableWaitingView, enableErrorMessage: enableErrorMessage, enableUnAuthorizedExit: enableUnAuthorizedExit, objectDebug:objectDebug, restrictSuccessHandler: restrictSuccessHandler, restrictErrorHandler: restrictErrorHandler)
            }
            break
        case .failure(let err):
            if enableWaitingView {
                // hide progress
                DispatchQueue.main.async {
                    RequestBuilder.shared.waitingView?(false);
                }
            }
            if enableErrorMessage{
                RequestBuilder.shared.errorMessage?("",err.localizedDescription);
            }
            restrictErrorHandler?(nil,err);
            break
        }
    }
    
    static func responseHandler(baseResponse:DataResponse<BaseResponse>!,
                                enableWaitingView:Bool,
                                enableErrorMessage:Bool,
                                enableUnAuthorizedExit:Bool,objectDebug:CustomDebugStringConvertible?,
                                restrictSuccessHandler:RequestOperationBuilder.RestrictSuccessHandler?,
                                restrictErrorHandler:RequestOperationBuilder.RestrictErrorHandler?){
        DispatchQueue.main.async {  UIApplication.shared.isNetworkActivityIndicatorVisible = false}
        if enableWaitingView {
            // hide progress
            DispatchQueue.main.async {
                RequestBuilder.shared.waitingView!(false);
            }
        }
        switch baseResponse.result {
        case .success(let response) :
         //   DebugError.debug(debugObject: self)
            if baseResponse.response?.statusCode == 200 ||  baseResponse.response?.statusCode == 204{
                restrictSuccessHandler?(response)
            }else{
                if baseResponse.response?.statusCode  == 401 && enableUnAuthorizedExit {
                    RequestBuilder.shared.exitHandler?();
                }
                restrictErrorHandler?(baseResponse.value,nil);
                if enableErrorMessage{
                    if baseResponse.response?.statusCode == 401 {
                        // show un auth message 
                        RequestBuilder.shared.errorMessage?("",baseResponse.value?.error?.bs_description ?? "");

                    }else{
                        RequestBuilder.shared.errorMessage?(baseResponse.value?.error?.bs_description ?? "",baseResponse.value?.error?.details?.joined(separator:"\n") ?? "");

                    }
                }else{
                }
            }
            break
        case .failure(let error) :
            if baseResponse.response?.statusCode == 204 {
                restrictSuccessHandler?(baseResponse.value)
            }else{
                if enableErrorMessage{
                    if error._code == NSURLErrorTimedOut {
                        RequestBuilder.shared.errorMessage?("","Common.ConnectionError".localized());

                    }else{
                    RequestBuilder.shared.errorMessage?("",error.localizedDescription);
                    }
                }
                restrictErrorHandler?(nil,error);
            }
            break
            
        }
    }
    
}
