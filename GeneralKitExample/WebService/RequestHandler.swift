//
//  RequestHandler.swift
//  Jobs
//
//  Created by Salah on 1/11/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
class RequestHandler {
    typealias ErrorHandler = (String) -> Void;
    typealias SuccessHandler = () -> Void;
    
    static func requestHandler(validationObject:ValidationObject,enableWaitingView:Bool,enableErrorMessage:Bool,successHandler:SuccessHandler?){
        if validationObject.success {
            if enableWaitingView {
                RequestBuilder.shared.waitingView!(true);
            }
            successHandler?();
        }else{
            if enableErrorMessage {
                RequestBuilder.shared.errorMessage?("Common.Error".localized(),validationObject.printMessage);
            }
        }
    }
}
