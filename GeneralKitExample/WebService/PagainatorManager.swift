//
//  PaginationWrapper.swift
//  NewLineTemplate
//
//  Created by Salah on 7/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import Foundation
import Alamofire



class PagainatorManager<T:BaseResponse>: NSObject {

    var restrictSuccessHandler: RequestOperationBuilder<T>.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder<T>.RestrictErrorHandler? = nil

    var baseRequest:BaseRequest?
    var currentPageKey:String?
    var perPageKey:String?
    var path :String?
    var requestBuilder:RequestOperationBuilder<T>?

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
    
    
    var baseResponse:T?
    
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
        self.requestBuilder = RequestOperationBuilder<T>.builder()
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
        DebugError.debug(hasNextPageHandler: self.hasNextPageHandler);
        DebugError.debug(hasPreviousPageHandler: self.hasPreviousPageHandler);
        DebugError.debug(currentPageHandler: self.currentPageHandler);
        self.parameter(value: self.currentPage?.string ?? "1", key: self.currentPageKey!)
     //   self.parameter(value: self.perPage, key: self.perPageKey!)
        self.requestBuilder?.url(self.path!);
        
        self.requestBuilder?.restrictSuccessHandler({ (response:BaseResponse?) in
            self.requestBuilder?.dataRequest = nil
            self.baseResponse = response as! T;
            self.currentPage = RequestBuilder.shared.currentPageHandler?(self);

            self.restrictSuccessHandler?(response);
        })
        
        self.requestBuilder?.restrictErrorHandler({ (baseResponse:BaseResponse?, error:Error?) in
            self.requestBuilder?.dataRequest = nil
            self.restrictErrorHandler?(baseResponse,error);
        })
        self.requestBuilder?.build();
        self.requestBuilder?.execute();

    }
    @discardableResult func restrictErrorHandler(_ restrictErrorHandler: @escaping RequestOperationBuilder<BaseResponse>.RestrictErrorHandler) -> PagainatorManager {
        self.restrictErrorHandler = restrictErrorHandler
        return self
    }
    @discardableResult func restrictSuccessHandler(_ restrictSuccessHandler: @escaping RequestOperationBuilder<BaseResponse>.RestrictSuccessHandler) -> PagainatorManager {
        self.restrictSuccessHandler = restrictSuccessHandler
        return self
    }
}


