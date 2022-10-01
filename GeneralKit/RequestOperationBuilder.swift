
//
//  RequestBuilder.swift
//  BuilderExample
//
//  Created by Salah on 3/26/20.
//  Copyright © 2020 Salah. All rights reserved.
//
/*
import ObjectMapper
import UIKit
import Alamofire
import AlamofireObjectMapper
import MBProgressHUD
import MagicalRecord
extension UIViewController {
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
class RequestOperationBuilder: NSObject {
    typealias ShowLoaderHandler = ()->UIViewController?
    static var showLoaderHandler : ShowLoaderHandler?
    static var unauthrzeRequests : [RequestOperationBuilder] = []
    var baseRequest:BaseRequest?
    var showLodaer:Bool=true
    var showMessage:Bool=false;
    typealias DidFinishHandler = ((SessionManager.MultipartFormDataEncodingResult?,DataResponse<BaseResponse>?) ->Swift.Void)
    var didFinishHandler:DidFinishHandler?
    var dataRequest:DataRequest!;
    var request:URLRequest!
    var dataResponse:DataResponse<BaseResponse>?
    var multipart : Bool = false
    var timeout : TimeInterval = 60
    var partAlamofire:((MultipartFormData) -> Void)={ (formData:MultipartFormData) in}
    static var header : HTTPHeaders=HTTPHeaders()
    var progressPresenterViewController : UIViewController?
    typealias HideHandler = (UIViewController)->Void
    static var hideLoadinghandler : HideHandler?
    
    // MARK: intenral
    private var isMultipart:Bool{
        return (self.baseRequest?.multiPartObjects.count ?? 0) > 0 || self.multipart
    }
    private var startDate:Date?
    private var endDate:Date?
    // MARK: input
    func request(_ request: BaseRequest)->Self{
        self.baseRequest = request
        return self
    }
    func multipart(_ multipart: Bool)->Self{
        self.multipart = multipart
        return self
    }
    func timeout(_ timeout : TimeInterval) -> Self{
        self.timeout = timeout
        return self
    }
    func showMessage(_ showMessage: Bool)->Self{
        self.showMessage = showMessage
        return self
    }
    func didFinishHandler(_ didFinishHandler:@escaping DidFinishHandler)->Self{
        self.didFinishHandler = didFinishHandler
        return self
    }
    
    func showLodaer(_ showLodaer: Bool)->Self{
        self.showLodaer = showLodaer
        return self
    }
    // MARK: build
    func paramters()->[String:String]{
        var dic = [String:String]();
        for object in (self.baseRequest?.parameters ?? Dictionary<String,String>()){
            let key = object.key
            let value = object.value.removeArNumberToEn()
            
            dic[key]=value;
        }
        return dic;
    }
    
    func build()->Self{
        if self.isMultipart{
            self.partAlamofire={ (formData:MultipartFormData) in
                for object in self.baseRequest?.multiPartObjects ?? []
                {
                    formData.append(object.data!, withName: object.name!, fileName: object.fileName!, mimeType: object.mimeType!)
                }
                for object in self.paramters() {
                    let key = object.key
                    let value = object.value.data(using:.utf8)!;
                    formData.append(value, withName:key);
                }
            }
        }
        do {
            if let type:HTTPMethod = self.baseRequest?.type , let url:URL = URL.init(string:self.baseRequest?.fullURL ?? ""){
                self.request = try URLRequest.init(url:url, method:type, headers:self.allHeaders());
                self.request = try URLEncoding.default.encode(self.request, with:paramters());
                self.request.timeoutInterval = timeout;
            }else{
                print("aa");
            }
        }catch {
            print(error);
        }
        // here you set your request
        return self
    }
    // MARK: execute with dataResponse
    func executeWithDataResponse(_ handler:@escaping (DataResponse<BaseResponse>)->Void)->Self{
         start()
        if isMultipart {
            executeMultiPartWithDataResponse(handler)
        }else{
            executeNormalWithDataResponse(handler)
        }
        return self
    }
    private func executeNormalWithDataResponse(_ handler:@escaping (DataResponse<BaseResponse>)->Void){
      let intenralHandler:(DataResponse<BaseResponse>)->Void = dataResponseHandler(handler: handler)
        self.dataRequest = Alamofire.SessionManager.default.request(self.request).responseObject(completionHandler:intenralHandler)
        // here you will run thee request
    }
    private func executeMultiPartWithDataResponse(_ handler:@escaping (DataResponse<BaseResponse>)->Void){
        let intenralHandler:(DataResponse<BaseResponse>)->Void = dataResponseHandler(handler: handler)
        Alamofire.upload(multipartFormData:self.partAlamofire, with: self.request) { (result) in
        ResponseHandler.checkResponseforMulipartObject(requestOpertion: self, showMessage:self.showMessage, response: result, handel:intenralHandler)
        }
    }
    // MARK: execute with checkResponse
    func executeWithCheckResponse(responseHandler:((BaseResponse)->Swift.Void)? = nil){
        start()
        if isMultipart {
            self.executeMultiPartWithCheckResponse(responseHandler: responseHandler);
        }else{
            self.executeNormalWithCheckResponse(responseHandler:responseHandler);
        }
    }
    private func executeNormalWithCheckResponse( responseHandler:((BaseResponse) ->Swift.Void)?){
        executeNormalWithDataResponse(){ handler in
            ResponseHandler.checkResponse(showMessage: self.showMessage, response: handler, handel: responseHandler, requestBuilder: self)
        }
        
    }
    private func  executeMultiPartWithCheckResponse(responseHandler:((BaseResponse)->Swift.Void)? = nil) {
        executeMultiPartWithDataResponse{ tempDataResponse in
            ResponseHandler.checkResponse(showMessage: self.showMessage, response:tempDataResponse, handel: responseHandler, requestBuilder: self)
        }
    }
    // MARK: handlers
    private func dataResponseHandler(handler:@escaping (DataResponse<BaseResponse>)->Void)->(DataResponse<BaseResponse>)->Void{
        let intenralHandler:(DataResponse<BaseResponse>)->Void = { dataResponse in
            print(self.request)
            print(self.dataRequest)
            print(String.init(bytes:dataResponse.data ??  Data(), encoding: .utf8) as? NSString ?? "");
            DispatchQueue.main.async {
                self.hideProgress()
#if DEBUG
                var requestDuration = self.startDate?.timeIntervalSinceNow ?? 0
                dataResponse.action()?.requestDuration=requestDuration;
#endif
                self.endDate = Date.init()
                ResponseDurationManager.sharedInstance.addPeriod(name: "\(self.baseRequest?.url ?? "")", firstTime: self.startDate ?? Date.init(), secondTime: self.endDate ?? Date.init(), period: self.startDate?.timeIntervalSinceNow ?? 0)
                self.didFinishHandler?(nil,dataResponse);
               handler(dataResponse)
            }
        }
        return intenralHandler
    }
    // MARK: extensions
    private func start(){
        self.startDate = Date.init();
        print("first date \(String(describing:self.startDate))")
        if self.showLodaer{
            DispatchQueue.main.async {
                self.progressPresenterViewController = RequestOperationBuilder.showLoaderHandler?()
            }
        }
    }
    private func allHeaders()->HTTPHeaders{
        var headers = HTTPHeaders();
        headers.bs_merge(dict:self.baseRequest?.header)
        headers.bs_merge(dict:RequestOperationBuilder.header)
        return headers;
    }
    func hideProgress(){
        if self.showLodaer,let vc : UIViewController = self.progressPresenterViewController{
            RequestOperationBuilder.hideLoadinghandler?(vc)
        }
    }
}
// MARK: BaseResponseHandler -> don't edit BaseResponseHandler here
class BaseResponseHandler:NSObject {
    fileprivate static func checkResponseforMulipartObject(requestOpertion:RequestOperationBuilder?,showMessage:Bool,response:SessionManager.MultipartFormDataEncodingResult,handel:@escaping (DataResponse<BaseResponse>)->Void){
        print("response is \(response)")
        print("response is \(response)")
        switch response{
        
        case .success(request: let request, streamingFromDisk: let streamingFromDisk, streamFileURL: let streamFileURL):
            var responseHandler = { (response : DataResponse<BaseResponse>) in
                print("response is \(response)")
                print("response is \(response.data?.string(encoding: .utf8))")
                print(String.init(bytes:response.data ??  Data(), encoding: .utf8) as? NSString ?? "");
                DispatchQueue.main.async { requestOpertion?.hideProgress()}
                handel(response);
            }
            request.responseObject(completionHandler: responseHandler)
            break;
        case .failure(let error):
            DispatchQueue.main.async { requestOpertion?.hideProgress()}
            self.showErrorMessage("AnErrorOccurred".localize_, showMessage)
            print(error)
            requestOpertion?.didFinishHandler?(response,nil)
           // handel(nil);
            break;
        }
    }
     static func showMessage(_ title:String,_ message:String,showMessage:Bool){
        if showMessage {
            if let vc = AppDelegate.delegate.navigationController?.visibleViewController{
                let alert = AlertBuilder.init(viewController: vc, style: .alert)
                alert.title(title).message(message).element(.button("OK".localize_, .default, nil)).execute()
            }
        }
    }
     static func showErrorMessage(_ message:String,_ showMessage:Bool){
        self.showMessage("Error".localize_, message, showMessage:showMessage)
    }
}
*/
