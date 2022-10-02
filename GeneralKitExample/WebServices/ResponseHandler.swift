//
//  ResponseHandler.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public class CutomResponseHandler<T:Mappable>:NSObject{
    func responseHandler(showMsg:Bool=true){

    }
}
 class PaginationResponseHandler:NSObject{
    var paginationManager:PaginationManager<BaseResponse>
     init(_ paginationManager: PaginationManager<BaseResponse>) {
         self.paginationManager = paginationManager
         self.paginationManager.hasNextPageHandler { response in
         
        return true
         }
         self.paginationManager.currentPageHandler { response in
             return response.response?.value?.pagination?.i_current_page?.intValue ?? 1;
         }
         self.paginationManager.hasPreviousPageHandler { response in
        return true
         }

     }
}
