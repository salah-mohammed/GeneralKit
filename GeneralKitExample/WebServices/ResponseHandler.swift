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
        }else{
            [MaintenanceError.init(dataReponse),
             NoInternetCheckError.init(dataReponse),
             AuthError.init(dataReponse),
             GeneralRemoteError.init(dataReponse)].checkWithOperation()
            error?();
        }
        
    }
}
 class PaginationResponseHandler:NSObject{
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
    func operation() -> Bool {
        return false;
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
    override func operation() -> Bool {
        Alert.show(nil,.error("", nil))
        return false
    }
}
class NoInternetCheckError:RemoteError{
    override var check: Bool{
        return  (errorCode == -1009) || (errorCode == -1020)
    }
    override func operation() -> Bool {
        Alert.show(nil,.error("", nil))
        return false
    }
}
class AuthError:RemoteError{
    override var check: Bool{
        return  self.statusCode == 401
    }
    override func operation() -> Bool {
        Alert.show(nil,.error("", nil))
        return false
    }
}

class GeneralRemoteError:RemoteError{
    override var check: Bool{
        return self.dataResponse?.error == nil && (200..<300).contains(self.statusCode ?? 0)
    }
    override func operation() -> Bool {
        Alert.show(nil,.error("خطأ غير معروف", nil))
        return false
    }
}
