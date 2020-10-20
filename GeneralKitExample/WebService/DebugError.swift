//
//  DebugError.swift
//  Jobs
//
//  Created by Salah on 1/11/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class DebugError{
    static func debug( errorGroup:String?){
        self.debug(string: errorGroup ?? "errorGroup = nil");
        if RequestBuilder.shared.enableDebug {
        RequestBuilder.shared.responseDebug?(errorGroup as? NSString)
        }
    }
    static func debug( string:String){
        print(string as! NSString)
    }
    static func debug(debug:GeneralListConstant.Handlers.ConverterHandler?){
        if debug == nil {
            assertionFailure("Error, converterHandler = nil ")
        }
    }
    static func debug(debug:GeneralListConstant.Handlers.RouterHandler?){
        if debug == nil {
            assertionFailure("Error, routerHandler = nil ")
        }
    }
    static func debug(debug:Selection.Handlers.ContainsCompletionHandler?){
        if debug == nil {
            assertionFailure("Error, containsCompletionHandler = nil ")
        }
    }
    static func debug(debug:URLRequest?){
        if debug == nil {
            assertionFailure("Error,You should Call build Funcation , call build()")
        }
    }
    static func debug(hasNextPageHandler:RequestBuilder.CheckPagainatorHandler?){
        if hasNextPageHandler == nil {
            assertionFailure("Error,hasNextPageHandler = nil ")
        }
    }
    static func debug(hasPreviousPageHandler:RequestBuilder.CheckPagainatorHandler?){
        if hasPreviousPageHandler == nil {
            assertionFailure("Error,hasPreviousPageHandler = nil ")
        }
    }
    static func debug(currentPageHandler:RequestBuilder.CurrentPageHandler?){
        if currentPageHandler == nil {
            assertionFailure("Error,currentPageHandler = nil ")
        }
    }
    
    static func debug(debugObject:CustomDebugStringConvertible?){
        #if DEBUG
        if RequestBuilder.shared.enableDebug {
            RequestBuilder.shared.responseDebug?((debugObject?.debugDescription as? NSString) ?? "");
        }
        #endif
    }
    static func traceErrors(result:SessionManager.MultipartFormDataEncodingResult,objectDebug:CustomStringConvertible){
        switch result {
        case .success(let request, let streamingFromDisk, let streamFileURL):
            request.responseObject { (response : DataResponse<BaseResponse>) in
                self.traceErrors(dataResponse: response, objectDebug: objectDebug,error:nil);
            }
            break
        case .failure(let err):
            DispatchQueue.main.async {
                self.traceErrors(dataResponse: nil, objectDebug: objectDebug,error:err,errorType:"MultiPartError");
            }
            break
        }
    }
    static func traceErrors(dataResponse:DataResponse<BaseResponse>?,objectDebug:CustomStringConvertible,error:Error?,errorType:String="alamofireError"){
        #if DEBUG
        if RequestBuilder.shared.enableDebug {
        RequestBuilder.shared.responseBuilderDebug?((objectDebug as! RequestOperationBuilder),error);
        if let reponse:DataResponse<BaseResponse> = dataResponse {
        switch reponse.result {
        case .success(let response) :
            self.traceErrors(status: dataResponse?.response?.statusCode, objectDebug: objectDebug,error:nil,errorType:errorType);
            break
            
        case .failure(let error) :
            self.traceErrors(status: dataResponse?.response?.statusCode, objectDebug: objectDebug,error:error,errorType:errorType);

            break
            
         }
        }else{
            var dataResponseError = "dataResponse = nil";
            self.traceErrors(status: dataResponse?.response?.statusCode, objectDebug: objectDebug,error:error,errorType:errorType,otherError:dataResponseError);
        }
            
        }
        #endif
}
    private static func traceErrors(status:Int?,objectDebug:CustomStringConvertible,error:Error?,errorType:String,otherError:String? = nil){
                if let statusValue:Int = status as? Int {
                    DebugError.debug(errorGroup:" status = \(status)")
            }
            else{
            var debugString = objectDebug.description;
                debugString.append("\n")
                debugString.append("\(errorType) = \(error.debugDescription ?? "nil")");
                debugString.append("\n")
                debugString.append(otherError ?? "nil");
                DebugError.debug(errorGroup: debugString);
            }
    }
    public static func traceErrors(status:Int?,objectDebug:CustomStringConvertible?){
        if var statusValue:Int = status as? Int {
        if status == 401 {
            DebugError.debug(string:objectDebug?.description ?? "objectDebug = nil");
            assert(false,"status = 401");
                   }else
            if statusValue == 404 {
                DebugError.debug(string:objectDebug?.description ?? "objectDebug = nil");
                assert(false,"status = 404");
                  }else
                if statusValue == 500 {
                    DebugError.debug(string:objectDebug?.description ?? "objectDebug = nil");
                    assert(false,"status = 500");
                }else
                if statusValue == 422 {
                    DebugError.debug(string:objectDebug?.description ?? "objectDebug = nil");
                    assert(false,"status = 422");
                        
                    }else
                if statusValue > 204 &&  statusValue <= 500 {
                    DebugError.debug(string:objectDebug?.description ?? "objectDebug = nil");
                    assert(false,"status = \(status))");
        }
        }
    }
}





