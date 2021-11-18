//
//  RequestBuilder.swift
//  NewLineTemplate
//
//  Created by Salah on 7/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public class RequestBuilder {
    typealias WaitingView = (Bool) -> Void;
    typealias ErrorMessage = (String,String) -> Void;
    typealias ResponseDebug = (NSString?) -> Void;
    typealias ResponseBuilderDebug = (RequestOperationBuilder<BaseResponse>,Error?) -> Void;
    typealias CheckPagainatorHandler = (PagainatorManager<BaseResponse>) -> Bool;
    typealias CurrentPageHandler = (PagainatorManager<BaseResponse>) -> Int;
    typealias ExitHandler = () -> Void;

    var waitingView: WaitingView? = nil
    var errorMessage: ErrorMessage? = nil
    var enableDebug: Bool = false
    var responseDebug: ResponseDebug? = nil
    var responseBuilderDebug: ResponseBuilderDebug? = nil
    var hasPreviousPageHandler:CheckPagainatorHandler?
    var hasNextPageHandler:CheckPagainatorHandler?
    var currentPageHandler:CurrentPageHandler?
    var exitHandler:ExitHandler?
    var baseURL:String?

    open var headers:HTTPHeaders = HTTPHeaders();
    
    static let shared: RequestBuilder = {
        let instance = RequestBuilder()
        
        return instance
    }()
    func baseURL(_ baseURL:String) {
        self.baseURL = baseURL
    }
    func exitHandler(_ exitHandler: @escaping ExitHandler) {
        self.exitHandler = exitHandler
    }
    func waitingView(_ waitingView: @escaping WaitingView) {
        self.waitingView = waitingView
    }
    func errorMessage(_ errorMessage: @escaping ErrorMessage) {
        self.errorMessage = errorMessage
    }
    func responseDebug(_ responseDebug: @escaping ResponseDebug) {
        self.responseDebug = responseDebug
    }
    func hasPreviousPageHandler(_ hasPreviousPageHandler: @escaping CheckPagainatorHandler) {
        self.hasPreviousPageHandler = hasPreviousPageHandler
    }
    func hasNextPageHandler(_ hasNextPageHandler: @escaping CheckPagainatorHandler) {
        self.hasNextPageHandler = hasNextPageHandler
    }
    func currentPageHandler(_ currentPageHandler: @escaping CurrentPageHandler) {
        self.currentPageHandler = currentPageHandler
    }
}


public class RequestOperationBuilder<T: BaseResponse>:NSObject{
    class func builder<T: BaseResponse>() -> RequestOperationBuilder<T> {
        return RequestOperationBuilder<T>()
    }
    override public var description: String {
        var string = String();
        string.append("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
        string.append("****************************************************RequestBuilderDebug******************************************************")
        string.append("\n");
        string.append("url = \(self.request.url?.absoluteString ?? "nil")");
        string.append("\n");
        string.append("methode = \(self.dataResponse?.request?.httpMethod ?? "nil")");
        string.append("\n");
        string.append("params = \(self.allParameters() ?? nil)");
        string.append("\n");
        string.append("requestBuilderHeaders = \(self.allHeaders())");
        string.append("\n");
        string.append("requestHeader = \(self.request.allHTTPHeaderFields ?? nil)");
        string.append("\n");
        string.append("status = \(self.dataResponse?.response?.statusCode.string ?? "nil" )");
        string.append("\n");
        string.append("path = \(self.url ?? "nil" )");
        string.append("\n");
        string.append("errorCode = \((self.dataResponse?.error as? NSError)?.code.string ?? "nil" )");
        string.append("\n");
        string.append("error debugDescription = \((self.dataResponse?.error as? NSError).debugDescription ?? "nil" )");
        string.append("\n");
        string.append("error localizedDescription = \((self.dataResponse?.error as? NSError)?.localizedDescription ?? "nil" )");
        string.append("\n");
        string.append("error userInfo debugDescription = \((self.dataResponse?.error as? NSError)?.userInfo.debugDescription ?? "nil" )");
        string.append("\n");
        string.append("stringResponse = \(self.dataResponse?.data?.string(encoding: .utf8) ?? "nil" )");
        return string
    }

    var dataResponse:DataResponse<BaseResponse>?
    var dataRequest:DataRequest!;
    typealias RestrictErrorHandler = (BaseResponse?,Error?) -> Void;
    typealias RestrictSuccessHandler = (BaseResponse?) -> Void;
    var restrictSuccessHandler: RestrictSuccessHandler? = nil
    var restrictErrorHandler: RestrictErrorHandler? = nil




    var url: String? = nil
    var baseRequest:BaseRequest?
    var methode:HTTPMethod = HTTPMethod.get;
    var enableWaitingView:Bool=false;
    var enableUnAuthorizedExit:Bool=true;
    var enableErrorMessage:Bool=true;

    var params : Dictionary<String, String> = Dictionary<String, String>();
    var validationObject = ValidationObject.init();
    var beforeSave: ((Any?) -> Any?)?
    var partAlamofire:((MultipartFormData) -> Void)?
    var   request:URLRequest!;
    func url(_ url: String) -> RequestOperationBuilder {
        self.url = url

        return self
    }
    @discardableResult func enableErrorMessage(_ enableErrorMessage: Bool) -> RequestOperationBuilder {
        self.enableErrorMessage = enableErrorMessage
        return self
    }
    
    @discardableResult func enableUnAuthorizedExit(_ enableUnAuthorizedExit: Bool) -> RequestOperationBuilder {
        self.enableUnAuthorizedExit = enableUnAuthorizedExit
        return self
    }
    @discardableResult func methode(_ methode: HTTPMethod) -> RequestOperationBuilder {
        self.methode = methode
        return self
    }
    @discardableResult func restrictErrorHandler(_ restrictErrorHandler: @escaping RestrictErrorHandler) -> RequestOperationBuilder {
        self.restrictErrorHandler = restrictErrorHandler
        return self
    }
    @discardableResult func restrictSuccessHandler(_ restrictSuccessHandler: @escaping RestrictSuccessHandler) -> RequestOperationBuilder {
        self.restrictSuccessHandler = restrictSuccessHandler
        return self
    }

    
    @discardableResult func enableWaitingView(_ enableWaitingView: Bool) -> RequestOperationBuilder {
        self.enableWaitingView = enableWaitingView
        return self
    }
    @discardableResult func params(_ params: Dictionary<String, String>) -> RequestOperationBuilder {
        self.params = params
        return self
    }
    @discardableResult func params(_ validationObject: ValidationObject) -> RequestOperationBuilder {
        self.validationObject = validationObject
        return self
    }
    
    @discardableResult func param(_ key: String, _ value: String) -> RequestOperationBuilder {
        self.params[key] = value
        return self
    }
    
   @discardableResult func beforeSave(_ block: ((Any?) -> Any?)!) -> RequestOperationBuilder {
        beforeSave = block
        return self
    }
    
    @discardableResult func validationObject(_ validationObject:ValidationObject) -> RequestOperationBuilder {
        self.validationObject = validationObject
        return self
    }
    
    func allParameters()->Dictionary<String,String>{
        var parameters:Dictionary<String,String> = Dictionary<String,String>();
        parameters.bs_merge(dict: self.baseRequest?.parameters ?? [:])
        parameters.bs_merge(dict: self.params ?? [:])
        return parameters;
    }
    func allHeaders()->HTTPHeaders{
        var headers:HTTPHeaders = HTTPHeaders();
        for object in  RequestBuilder.shared.headers {
            headers.updateValue(object.value, forKey: object.key)
        }
        for object in  self.baseRequest?.header ?? [:] {
            headers.updateValue(object.value, forKey: object.key)
        }
        return headers;
    }
    func fullUrl()->String{
        return self.baseRequest?.fullURL ?? "\(RequestBuilder.shared.baseURL ?? "")/\(self.url!)"
    }
    func currentMethode()->HTTPMethod{
        return self.baseRequest?.type ?? self.methode
    }
   @discardableResult public func build() -> RequestOperationBuilder {
    let headers = allHeaders();
    if self.baseRequest?.multiPartObjects.count ?? 0 > 0{
        self.partAlamofire={ (formData:MultipartFormData) in

            for  object in self.baseRequest?.multiPartObjects ?? []
            {
                formData.append(object.data!, withName: object.name!, fileName: object.fileName!, mimeType: object.mimeType!)
            }

            for  object in self.allParameters()
            {
                let key = object.key
              
                    let value = object.value.data(using:.utf8)!;
                    formData.append(value, withName:key);
                
            }
        }
    }
            do {
                self.request = try URLRequest.init(url:URL.init(string:self.fullUrl())!, method: self.currentMethode(), headers:headers);
                self.request = try URLEncoding.default.encode(self.request, with:allParameters());
                print(self.request);
 
            }
            catch { }

        return self
        
    }

   private func  executeMultiPart() {
    
    Alamofire.upload(multipartFormData: self.partAlamofire!, with: self.request) { (result) in
        DebugError.traceErrors(result: result, objectDebug: self);

        ResponseHandler.responseHandler(result: result, enableErrorMessage: self.enableErrorMessage, enableWaitingView: self.enableWaitingView, enableUnAuthorizedExit: self.enableUnAuthorizedExit, objectDebug: self.debugDescription as NSString, restrictSuccessHandler: self.restrictSuccessHandler, restrictErrorHandler: self.restrictErrorHandler, dataResponse: { (dataResponse:DataResponse<BaseResponse>) in
            self.dataResponse=dataResponse;
        })

    }
    }

   private func  executeRequest(){
    self.dataRequest = Alamofire.SessionManager.default.request(self.request).responseObject { (response : DataResponse<BaseResponse>) in
        self.dataResponse = response;
        DebugError.traceErrors(dataResponse: response, objectDebug: self, error: nil);
        ResponseHandler.responseHandler(baseResponse:response, enableWaitingView: self.enableWaitingView, enableErrorMessage: self.enableErrorMessage, enableUnAuthorizedExit: self.enableUnAuthorizedExit, objectDebug: self.debugDescription as NSString, restrictSuccessHandler: self.restrictSuccessHandler, restrictErrorHandler: self.restrictErrorHandler)
    }
    }
    private func executeRequestToServer(){
    if partAlamofire != nil {
    self.executeMultiPart();
    }else{
    self.executeRequest();
    }
    }
    @discardableResult func execute() ->RequestOperationBuilder {
        DebugError.debug(debug: self.request)
        RequestHandler.requestHandler(validationObject: self.validationObject, enableWaitingView: self.enableWaitingView, enableErrorMessage: self.enableErrorMessage) {
            self.executeRequestToServer();
        }
        return self;
    }
    
}
