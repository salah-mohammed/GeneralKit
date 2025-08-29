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
//import SalahUtility

open class BaseModel:Mappable{
    required  public init?(map: ObjectMapper.Map) {
        self.mapping(map:map);
    }
    
    open func mapping(map: ObjectMapper.Map) {
        
    }
    
    
}

public class RequestBuilder {
    public enum SimulateLocalResponse{
    case local // read local file only
    case remote // read remote json file only
    case combain // if local file not not use it
    }
    
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
    public var simulateLocalResponse: SimulateLocalResponse = .remote

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
public class RequestOperationBuilder<T:Mappable>:NSObject,ObservableObject{
    public typealias FinishData = DataResponse<T,AFError>
    public typealias FinishHandler = ((FinishData)->Void)
    public var responseHandler:FinishHandler?
    var dataRequest:DataRequest?;
    var request:URLRequest?
    var dataResponse:FinishData?
    public var baseRequest:BaseRequest?
    var multipart : Bool = false
    var timeout : TimeInterval = 60
    var showLoader:Bool=true;
    open var encoding:ParameterEncoding =  URLEncoding.default
    @Published public var isLoading:Bool=false

    var partAlamofire:((MultipartFormData) -> Void)={ (formData:MultipartFormData) in}
    // MARK: intenral
    private var isMultipart:Bool{
        return (self.baseRequest?.multiPartObjects.count ?? 0) > 0 || self.multipart
    }
    // MARK: build
    func paramters()->Parameters{
        var dic = Parameters();
        for object in (self.baseRequest?.parameters ?? Parameters()){
            let key = object.key
            if var  value :  String = object.value as? String{
                value = value.bs_arNumberToEn()
                dic[key]=value;
            }else{
                dic[key]=object.value;
            }
        }
        return dic;
    }
    @discardableResult public func build()->Self{
        if self.isMultipart{
            self.partAlamofire={ [weak self] (formData:MultipartFormData) in
                for object in self?.baseRequest?.multiPartObjects ?? []
                {
                 if let data:Data = object.data{
                    formData.append(data, withName:object.name ?? "", fileName: object.fileName ?? "", mimeType: object.mimeType ?? "")
                 }
                }
                for object in self?.paramters() ?? [:] {
                    let key = object.key
                    if let value:Data = (object.value as AnyObject).data(using: String.Encoding.utf8.rawValue){
                        formData.append(value, withName:key);
                    }
                }
            }
        }
        do {
            if let type:HTTPMethod = self.baseRequest?.type , let url:URL = URL.init(string:self.baseRequest?.fullURL ?? ""){
                self.request = try URLRequest.init(url:url, method:type, headers:self.allHeaders());
                if let request:URLRequest = self.request{
                    self.request = try encoding.encode(request, with:paramters());
                }
                self.request?.timeoutInterval = timeout;
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
        if let request:URLRequest = self.request{
            switch  RequestBuilder.shared.simulateLocalResponse {
            case .local:
                // ✅ Check for local JSON first
                if let localURL = baseRequest?.localJsonURL?.bs_fileURL {
                    simulateLocalResponse(from: localURL)
                }
                break;
            case .remote:
                remoteResponse(request:request)
                break;
            case .combain:
                if let localURL = baseRequest?.localJsonURL?.bs_fileURL{
                    simulateLocalResponse(from: localURL)
                }else{
                    remoteResponse(request:request)
                }
                break;
            }
        }
    }
    private func remoteResponse(request:URLRequest){
        self.isLoading = true;
        if showLoader{
        RequestBuilder.shared.waitingView?(true);
        }
        if self.isMultipart{
            self.dataRequest = AF.upload(multipartFormData:self.partAlamofire, with:request)
        }else{
            self.dataRequest = AF.request(request)
        }
        self.dataRequest?.responseObject{ [weak self] (response:DataResponse<T,AFError>) in
            DispatchQueue.main.async {
                self?.isLoading=false;
                self?.dataRequest=nil;
                if self?.showLoader ?? false{
                    RequestBuilder.shared.waitingView?(false);
                }
                self?.dataResponse=response;
                self?.responseHandler?(response);
            }
        }
    }
    private func simulateLocalResponse(from localURL: URL) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let data = try Data(contentsOf: localURL)
                if let jsonString = String(data: data, encoding: .utf8),
                   let mappedObject = T(JSONString: jsonString) {
                    
                    let urlResponse = HTTPURLResponse(
                        url: localURL,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    
                    let dataResponse = DataResponse<T, AFError>(
                        request: nil,
                        response: urlResponse,
                        data: data,
                        metrics: nil,
                        serializationDuration: 0,
                        result: .success(mappedObject)
                    )
                    
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.dataResponse = dataResponse
                        self?.responseHandler?(dataResponse)
                    }
                }
            } catch {
                let afError = AFError.explicitlyCancelled
                let dataResponse = DataResponse<T, AFError>(
                    request: nil,
                    response: nil,
                    data: nil,
                    metrics: nil,
                    serializationDuration: 0,
                    result: .failure(afError)
                )
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.responseHandler?(dataResponse)
                }
            }
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
    @discardableResult public func timeout(_ timeout:TimeInterval)->Self{
        self.timeout=timeout;
        return self
    }
    @discardableResult public func multipart(_ multipart:Bool)->Self{
        self.multipart=multipart;
        return self
    }
    @discardableResult public func encoding(_ encoding:ParameterEncoding)->Self{
        self.encoding=encoding;
        return self;
    }
}
