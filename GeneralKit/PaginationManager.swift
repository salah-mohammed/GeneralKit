//
//  PaginationManager.swift
//  GeneralKit
//
//  Created by Salah on 10/1/22.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SalahUtility

public class PaginationManager<T:Mappable>:NSObject{
    public typealias CheckPagainatorHandler = (PaginationManager<T>) -> Bool;
    public typealias CurrentPageHandler = (PaginationManager<T>) -> Int;
    
    var baseRequest:BaseRequest?
    var responseHandler:RequestOperationBuilder<T>.FinishHandler?
    public var response:RequestOperationBuilder<T>.FinishData?;
    var requestBuilder:RequestOperationBuilder<T>

    private var hasNextPage:Bool{
        if self.hasNextPageHandler?(self) ?? false {
            return true;
        }
        return false
    }
    private var isLoading:Bool
    {
        if self.requestBuilder.dataRequest  == nil{return false;}
        return true;
    }
    private var hasPreviousPage:Bool{
        if self.hasPreviousPageHandler?(self) ?? false {
            return true;
        }
        return false
    }
    public var currentPage:Int?
    public var hasPreviousPageHandler:CheckPagainatorHandler?
    public var hasNextPageHandler:CheckPagainatorHandler?
    public var currentPageHandler:CurrentPageHandler?
    
    public override init() {
        self.requestBuilder = RequestOperationBuilder<T>.init();
    }
    // for refresh
    public func start(){
        if self.requestBuilder.dataRequest != nil {
            self.requestBuilder.dataRequest?.cancel();
        }
        self.currentPage=1;
        self.paginatorRequest();
    }
    public func loadNextPage(){
        if self.hasNextPage {
            self.currentPage! += 1
            self.paginatorRequest();
        }
    }
    public func loadPreviousPage(){
        if  self.hasPreviousPage {
            self.currentPage! -= 1
            self.paginatorRequest();
        }
    }
    private func paginatorRequest(){
        self.baseRequest?.page=self.currentPage?.bs_string ?? "1"
        if let baseRequest:BaseRequest = self.baseRequest{
            self.requestBuilder.baseRequest(baseRequest);
        }
        self.requestBuilder.responseHandler { response in
            self.response=response;
            self.responseHandler?(response);
            self.currentPage = self.currentPageHandler?(self);
        }
        self.requestBuilder.build();
        self.requestBuilder.execute();
    }
    
    @discardableResult public func hasPreviousPageHandler(_ hasPreviousPageHandler:@escaping CheckPagainatorHandler)->Self{
        self.hasPreviousPageHandler=hasPreviousPageHandler;
        return self
    }
    @discardableResult public func hasNextPageHandler(_ hasNextPageHandler:@escaping CheckPagainatorHandler)->Self{
        self.hasNextPageHandler=hasNextPageHandler;
        return self
    }
    @discardableResult public func currentPageHandler(_ currentPageHandler:@escaping CurrentPageHandler)->Self{
        self.currentPageHandler=currentPageHandler;
        return self
    }
    @discardableResult public func baseRequest(_ baseRequest:BaseRequest)->Self{
        self.baseRequest=baseRequest;
        return self
    }
    @discardableResult public func responseHandler(_ responseHandler:RequestOperationBuilder<T>.FinishHandler?)->Self{
        self.responseHandler=responseHandler;
        return self
    }
}
/*
 class PagainatorManager: NSObject {

     var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
     var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil


     var currentPageKey:String?
     var perPageKey:String?
     var path :String?
     var requestBuilder:RequestOperationBuilder?

     var parameters:Dictionary<String,String>
     {
         set{
             self.requestBuilder!.params(newValue);
         }
         get{
            return self.requestBuilder!.params;
         }
     }
     public var currentPage:Int?

     var hasPreviousPageHandler:RequestBuilder.CheckPagainatorHandler? = RequestBuilder.shared.hasPreviousPageHandler
     var hasNextPageHandler:RequestBuilder.CheckPagainatorHandler? = RequestBuilder.shared.hasNextPageHandler
     var currentPageHandler:RequestBuilder.CurrentPageHandler? = RequestBuilder.shared.currentPageHandler
     
     
     var baseResponse:BaseResponse?
     
     var hasNextPage:Bool{
         if self.hasNextPageHandler?(self) ?? false {
             return true;
         }
         return false
     }
     var isLoading:Bool
     {
         if self.requestBuilder!.dataRequest  == nil{return false;}
         return true;
       //  return  self.requestBuilder!.dataRequest.i
     }
     var hasPreviousPage:Bool{
         if self.hasPreviousPageHandler?(self) ?? false {
             return true;
         }
         return false
     }
     
     
     
     public func start(){
         
         if self.requestBuilder!.dataRequest != nil {
             self.requestBuilder!.dataRequest!.cancel();
         }
         self.currentPage=1;
  
         self.paginatorRequest();
         
         
         
         
     }
     
     public func currentPageKey(_ currentPageKey:String){
         self.currentPageKey=currentPageKey;
     }
     public func perPageKey(_ perPageKey:String){
         self.perPageKey=perPageKey;
     }
     public func path(_ path:String){
         self.path = path;

     }

     public func currentPage(_ currentPage:Int){
         self.currentPage=currentPage;
     }
     public func parameter(value:String,key:String)
     {
         self.requestBuilder?.param(key, value)
     }
     public func requestMethod(_ requestMethod:HTTPMethod)
     {
         
         self.requestBuilder!.methode = requestMethod;
     }


     
     
     
     override init() {
         super.init();
         DebugError.debug(hasNextPageHandler: self.hasNextPageHandler);
         DebugError.debug(hasPreviousPageHandler: self.hasPreviousPageHandler);
         DebugError.debug(currentPageHandler: self.currentPageHandler);
         self.requestBuilder = RequestBuilder.builder()
     }
     
     func loadNextPage()
     {
         if self.hasNextPage {
             self.currentPage! += 1
             
             self.paginatorRequest();
             
             
             
         }
         
     }
     
     func loadPreviousPage()
     {
         if  self.hasPreviousPage {
             self.currentPage! -= 1
             self.paginatorRequest();
             
             
         }
         
     }
     func paginatorRequest(){
         if let currentPageKey:String = self.currentPageKey{
         self.parameter(value: self.currentPage?.string ?? "1", key:currentPageKey)
         }
      //   self.parameter(value: self.perPage, key: self.perPageKey!)
         self.requestBuilder?.url(self.path!);
         
         self.requestBuilder?.restrictSuccessHandler({ (response:BaseResponse?) in
             self.baseResponse = response;
             if self.currentPageKey != nil{
             self.currentPage = RequestBuilder.shared.currentPageHandler?(self);
             }
             self.restrictSuccessHandler?(response);
         })
         
         self.requestBuilder?.restrictErrorHandler({ (baseResponse:BaseResponse?, error:Error?) in
             self.restrictErrorHandler?(baseResponse,error);
         })
         self.requestBuilder?.build();
         self.requestBuilder?.execute();

     }
     @discardableResult func restrictErrorHandler(_ restrictErrorHandler: @escaping RequestOperationBuilder.RestrictErrorHandler) -> PagainatorManager {
         self.restrictErrorHandler = restrictErrorHandler
         return self
     }
     @discardableResult func restrictSuccessHandler(_ restrictSuccessHandler: @escaping RequestOperationBuilder.RestrictSuccessHandler) -> PagainatorManager {
         self.restrictSuccessHandler = restrictSuccessHandler
         return self
     }
 }
 */
