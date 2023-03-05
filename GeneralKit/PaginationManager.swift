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

public protocol PaginationManagerProtocol{
var hasNextPage:Bool{get}
var isLoading:Bool{get}
var showLoader:Bool{get set}
var UICurrentPage:Int?{get}
func loadNextPage()
func start();
}
public class PaginationManager<T:Mappable>:NSObject,PaginationManagerProtocol{
    public typealias CheckPagainatorHandler = (PaginationManager<T>) -> Bool;
    public typealias CurrentPageHandler = (PaginationManager<T>) -> Int;
    
    var baseRequest:BaseRequest?
    var responseHandler:RequestOperationBuilder<T>.FinishHandler?
    public var response:RequestOperationBuilder<T>.FinishData?;
    var requestBuilder:RequestOperationBuilder<T>
    var testHandler:RequestOperationBuilder<T>.FinishHandler?
    public var showLoader:Bool=true{
        didSet{
            self.requestBuilder.showLoader=showLoader
        }
    }

    public var hasNextPage:Bool{
        if self.hasNextPageHandler?(self) ?? false {
            return true;
        }
        return false
    }
    public var isLoading:Bool
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
    public var UICurrentPage:Int?{
    return self.currentPageHandler?(self)
    }

    private var hasPreviousPageHandler:CheckPagainatorHandler?
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
    private func loadPreviousPage(){
        if  self.hasPreviousPage {
            self.currentPage! -= 1
            self.paginatorRequest();
        }
    }
    private func paginatorRequest(){
        self.requestBuilder.showLoader = self.showLoader
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
    
    @discardableResult private func hasPreviousPageHandler(_ hasPreviousPageHandler:@escaping CheckPagainatorHandler)->Self{
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


