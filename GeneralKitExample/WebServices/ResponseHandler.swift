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

extension RequestOperationBuilder<BaseResponse> {
    func executeWithCheckResponse(_ successFinish:((BaseResponse)->Void)?,
                             error:(()->Void)? = nil){
        self.responseHandler { dataResponse in
            ResponseHandler.check(dataResponse, successFinish,error:error)
        }.execute()
    }
}
public class ResponseHandler:NSObject{
    static func check(_ dataReponse:DataResponse<BaseResponse,AFError>,
                               _ successFinish:((BaseResponse)->Void)?,
                               error:(()->Void)? = nil){
        if let value:BaseResponse = dataReponse.value {
            successFinish?(value)
        }else{
            error?();
        }
        
    }
}
 class PaginationResponseHandler:NSObject{
    var paginationManager:PaginationManager<BaseResponse>
     init(_ paginationManager: PaginationManager<BaseResponse>) {
         self.paginationManager = paginationManager
         self.paginationManager.hasNextPageHandler { response in
             if let currentPage:Int = response.currentPage,
                let totalPages:Int = response.response?.value?.pagination?.i_total_pages?.intValue{
                return (currentPage < totalPages)
             }else{
            return false
             }
         }
         self.paginationManager.currentPageHandler { response in
             return response.response?.value?.pagination?.i_current_page?.intValue ?? 1;
         }
     }
}
