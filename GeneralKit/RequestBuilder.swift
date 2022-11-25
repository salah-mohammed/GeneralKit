//
//  RequestBuilder.swift
//  GeneralKit
//
//  Created by Salah on 9/24/22.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SalahUtility

open class BaseModel:Mappable{
    required  public init?(map: ObjectMapper.Map) {
        self.mapping(map:map);
    }
    
    open func mapping(map: ObjectMapper.Map) {
        
    }
    
    
}

public class RequestBuilder {
    var unauthrzeRequests = [RequestOperationBuilder<BaseModel>]()
    public typealias WaitingView = (Bool) -> Void;
    public typealias ErrorMessage = (String,String) -> Void;
    public typealias ResponseDebug = (NSString?) -> Void;
//    typealias ResponseBuilderDebug = (RequestOperationBuilder,Error?) -> Void;
//    typealias CheckPagainatorHandler = (PagainatorManager) -> Bool;
//    typealias CurrentPageHandler = (PagainatorManager) -> Int;

    var waitingView: WaitingView? = nil
    var errorMessage: ErrorMessage? = nil
    var enableDebug: Bool = false
    var responseDebug: ResponseDebug? = nil
//    var responseBuilderDebug: ResponseBuilderDebug? = nil
//    var hasPreviousPageHandler:CheckPagainatorHandler?
//    var hasNextPageHandler:CheckPagainatorHandler?
//    var currentPageHandler:CurrentPageHandler?

    open var headers:HTTPHeaders = HTTPHeaders();
    
    public static let shared: RequestBuilder = {
        let instance = RequestBuilder()

        return instance
    }()
    public func waitingView(_ waitingView: @escaping WaitingView) {
        self.waitingView = waitingView
    }
    public func errorMessage(_ errorMessage: @escaping ErrorMessage) {
        self.errorMessage = errorMessage
    }
    public func responseDebug(_ responseDebug: @escaping ResponseDebug) {
        self.responseDebug = responseDebug
    }
//    func hasPreviousPageHandler(_ hasPreviousPageHandler: @escaping CheckPagainatorHandler) {
//        self.hasPreviousPageHandler = hasPreviousPageHandler
//    }
//    func hasNextPageHandler(_ hasNextPageHandler: @escaping CheckPagainatorHandler) {
//        self.hasNextPageHandler = hasNextPageHandler
//    }
//    func currentPageHandler(_ currentPageHandler: @escaping CurrentPageHandler) {
//        self.currentPageHandler = currentPageHandler
//    }
}
public class RequestOperationBuilder<T:Mappable>:NSObject{
    public typealias FinishData = DataResponse<T,AFError>
    public typealias FinishHandler = ((FinishData)->Void)
    var responseHandler:FinishHandler?
    var dataRequest:DataRequest!;
    var request:URLRequest!
    var dataResponse:FinishData?
    var baseRequest:BaseRequest?
    var multipart : Bool = false
    var timeout : TimeInterval = 60
    var showLoader:Bool=true;
    var urlEncoding:URLEncoding = .default
    var partAlamofire:((MultipartFormData) -> Void)={ (formData:MultipartFormData) in}
    // MARK: intenral
    private var isMultipart:Bool{
        return (self.baseRequest?.multiPartObjects.count ?? 0) > 0 || self.multipart
    }
    // MARK: build
    func paramters()->[String:String]{
        var dic = [String:String]();
        for object in (self.baseRequest?.parameters ?? Dictionary<String,String>()){
            let key = object.key
            let value = object.value.bs_arNumberToEn()
            
            dic[key]=value;
        }
        return dic;
    }
    @discardableResult public func build()->Self{
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
                self.request = try self.urlEncoding.encode(self.request, with:paramters());
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
     private func allHeaders()->HTTPHeaders{
         var dic:[String: String]=[String: String]();
         dic.bs_merge(dict:self.baseRequest?.header?.dictionary ?? [:])
         dic.bs_merge(dict:RequestBuilder.shared.headers.dictionary)
         return HTTPHeaders.init(dic)
     }
    public func execute(){
        if showLoader{
        RequestBuilder.shared.waitingView?(true);
        }
        if self.isMultipart{
            self.dataRequest = AF.upload(multipartFormData:self.partAlamofire, with: self.request)
        }else{
            self.dataRequest = AF.request(self.request)
        }
        self.dataRequest.responseObject{ (response:DataResponse<T,AFError>) in
            self.dataRequest=nil;
            if self.showLoader{
                RequestBuilder.shared.waitingView?(false);
            }
            self.dataResponse=response;
            self.responseHandler?(response);
        }
    }
    @discardableResult public func responseHandler(_ responseHandler:FinishHandler?)->Self{
        self.responseHandler=responseHandler;
        return self
    }
    @discardableResult public func baseRequest(_ baseRequest:BaseRequest)->Self{
        self.baseRequest=baseRequest;
        return self
    }
    
    @discardableResult public func urlEncoding(_ urlEncoding:URLEncoding)->Self{
        self.urlEncoding=urlEncoding;
        return self;
    }
    @discardableResult public func timeout(_ timeout:TimeInterval)->Self{
        self.timeout=timeout;
        return self
    }
    @discardableResult public func multipart(_ multipart:Bool)->Self{
        self.multipart=multipart;
        return self
    }
    
}
