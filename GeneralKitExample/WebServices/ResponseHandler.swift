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

extension DataResponse<BaseResponse,AFError>{
    func check(_ successFinish:((BaseResponse)->Void)?,error:(()->Void)? = nil){
        if let baseResponse:BaseResponse = self.value{
            successFinish?(baseResponse);
        }else{
            error?();
        }
    }
}
//public class ResponseHandler<T:Mappable>:NSObject{
//  
//}
 class PaginationResponseHandler:NSObject{
    var paginationManager:PaginationManager<BaseResponse>
     init(_ paginationManager: PaginationManager<BaseResponse>) {
         self.paginationManager = paginationManager
         self.paginationManager.hasNextPageHandler { response in
             if let currentPage:Int = response.currentPage,
                let totalPages:Int = response.response?.value?.pagination?.i_total_pages?.bs_Int{
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
