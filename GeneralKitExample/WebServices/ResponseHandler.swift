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
import SalahUtility
public let mappingDateFormate = ""

extension RequestOperationBuilder<BaseResponse> {
    func executeWithCheckResponse(_ successFinish:((BaseResponse)->Void)?,
                             error:(()->Void)? = nil){
        self.responseHandler { dataResponse in
            ResponseHandler.check(dataResponse, successFinish,error:error)
        }.execute()
    }
}
public class ResponseHandler:NSObject{
    static func check(_ dataReponse:(DataResponse<BaseResponse,AFError>)?,
                               _ successFinish:((BaseResponse)->Void)?,
                               error:(()->Void)? = nil){

        if let value:BaseResponse = dataReponse?.value {
            successFinish?(value)
        }else if let jsonArray:String = dataReponse?.data?.utf8String,
                 let value:BaseResponse = Mapper<BaseResponse>().map(JSONString:"{ \"data\": \(jsonArray)}"){
            successFinish?(value)
        }else
        if dataReponse?.response?.statusCode == 200 ||
           dataReponse?.response?.statusCode == 204,
          let emptyBaseResponse = Mapper<BaseResponse>().map(JSON: [:]) ?? BaseResponse(map: Map(mappingType: .fromJSON, JSON: [:])){
            successFinish?(emptyBaseResponse)
        }
        else{
            [MaintenanceError.init(dataReponse),
             NoInternetCheckError.init(dataReponse),
             AuthError.init(dataReponse),
             GeneralRemoteError.init(dataReponse)].checkWithOperation()
            error?();
        }
        
    }
}
// MARK: - PaginationResponseHandler if api base on page number
 class PagePaginationResponseHandler:NSObject{
    weak var paginationManager:PaginationManager<BaseResponse>?
     init(_ paginationManager: PaginationManager<BaseResponse>) {
         self.paginationManager = paginationManager
         self.paginationManager?.hasNextPageHandler{ paginationManager ,response in
             if let currentPage:Int = paginationManager.currentPage,
                let totalPages:Int = response?.value?.pagination?.i_total_pages?.bs_Int{
                return (currentPage < totalPages)
             }else{
            return false
             }
         }
         self.paginationManager?.currentPageHandler {_ ,response in
             return response?.value?.pagination?.i_current_page?.intValue ?? 1;
         }
     }
}
// MARK: - PaginationResponseHandler if api base on offset
class OffsetPaginationResponseHandler:NSObject{
    weak var paginationManager:PaginationManager<BaseResponse>?
     init(_ paginationManager: PaginationManager<BaseResponse>) {
         self.paginationManager = paginationManager
         self.paginationManager?.hasNextPageHandler{ paginationManager ,response in
             if let limit:Int = response?.value?.metadata?.resultset?.limit,
                let count:Int = response?.value?.metadata?.resultset?.count,
                let offset:Int = response?.value?.metadata?.resultset?.offset{
                 return (offset + limit) >= count
             }else{
               return false
             }
         }
         self.paginationManager?.currentPageHandler {_ ,response in
             if let resultset = response?.value?.metadata?.resultset,
                let offset:Int = resultset.offset,
                let limit:Int = resultset.limit{
                 return PaginationManager<BaseResponse>.getPageValueFrom(offset: offset, limit: limit) ?? 1
             }else{
               return 1
             }
         }
     }
}

protocol RemoteErrorProtocol{
var dataResponse:DataResponse<BaseResponse,AFError>?{set get}
}
class RemoteError:ConditionProtocol,RemoteErrorProtocol{
    var dataResponse:DataResponse<BaseResponse,AFError>?
    init(_ dataResponse:DataResponse<BaseResponse,AFError>?) {
        self.dataResponse=dataResponse
    }
    var subConditions:[ConditionProtocol]{
     return []
    }
    var check: Bool{
      return false
    }
    func operation(){

    }
    var statusCode:Int?{
      return self.dataResponse?.response?.statusCode
    }
    var errorCode:Int?{
        return self.dataResponse?.error?._code
    }
}
class MaintenanceError:RemoteError{
    override var check:Bool{
        return statusCode == 500 || statusCode == 404
    }
    override func operation(){
        AppAlert.show(nil,.error("", nil))
    }
}
class NoInternetCheckError:RemoteError{
    override var check: Bool{
        return  (errorCode == -1009) || (errorCode == -1020)
    }
    override func operation(){
        AppAlert.show(nil,.error("", nil))
    }
}
class AuthError:RemoteError{
    override var check: Bool{
        return  self.statusCode == 401
    }
    override func operation(){
        AppAlert.show(nil,.error("", nil))
    }
}

class GeneralRemoteError:RemoteError{
    override var check: Bool{
        return self.dataResponse?.error == nil && (200..<300).contains(self.statusCode ?? 0)
    }
    override func operation(){
        AppAlert.show(nil,.error("خطأ غير معروف", nil))
    }
}
