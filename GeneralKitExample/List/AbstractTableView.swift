//
//  GeneralTableView.swift
//  NewLineTemplate
//
//  Created by Salah on 7/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import Foundation


import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll
import Alamofire


class AbstractTableView: UITableView {
    var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil
    typealias RouterHandler = (BaseResponse) ->[Any];


    public var objects:Variable<[Any]>=Variable<[Any]>([]);
    var paginator:PagainatorManager?
    var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?
    var routerHandler:RouterHandler?
    
    public func start(){
        self.objects.value.removeAll();
        self.refreshControl?.beginRefreshing()
        self.paginator?.start();
    }
   @discardableResult public func setup()->Self{
        paginator=PagainatorManager.init();
        self.addInfiniteScroll { (tableView:UITableView) in
            self.loadMore();
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.black;
        
        self.paginator?.currentPageKey("page");
        self.paginator?.perPageKey("i_per_pages")
        return self;
    }
    
    private func loadMore(){
        if ((self.paginator?.isLoading==false)&&(self.paginator?.hasNextPage)!){
            self.paginator?.loadNextPage();
        }
        else{
            self.finishInfiniteScroll();
        }
        
    }
    @objc func performToPullToRefresh(){
        self.refreshControl?.beginRefreshing();
        self.objects.value.removeAll();
        self.paginator?.start();
        self.refreshHandler?()
    }
    
    
    private func defaultFailurePaginatorCompletionHandler(){
        if self.refreshControl?.isRefreshing ?? false
        { // pull to refresh
            self.refreshControl?.endRefreshing()
        }
        
        if self.isAnimatingInfiniteScroll {
            // load more
            self.finishInfiniteScroll();
        }
    }
    private func defaultSuccessHandler(paginator:PagainatorManager?, objects:[Any]?, index:Int?){
        if index==1{
            // pull to refresh
            self.objects.value.removeAll();
        }
        print(index);
        self.objects.value += objects!;
        
        //.reversed()
        // refreshView
        if self.refreshControl?.isRefreshing ?? false
        { // pull to refresh
            self.refreshControl?.endRefreshing()
        }
        if self.isAnimatingInfiniteScroll {
            // load more
            self.finishInfiniteScroll();
        }
    }
    
   @discardableResult func paramter(value:String,key:String) -> Self{
        self.paginator?.parameter(value: value, key: key)
        return self;
    }
   @discardableResult func routerHandler(_ routerHandler:@escaping RouterHandler) -> Self{
        self.routerHandler = routerHandler;
        return self;

    }
   @discardableResult func build() -> Self{
   //     self.paginator?.perPage=15;
        self.paginator?.restrictErrorHandler({ (baseResponse:BaseResponse?,error:Error?) in
            self.defaultFailurePaginatorCompletionHandler();

            self.restrictErrorHandler?(baseResponse,error);
        })
        self.paginator?.restrictSuccessHandler({ (baseResponse:BaseResponse?) in
            self.defaultSuccessHandler(paginator: self.paginator, objects:self.routerHandler!(baseResponse!), index: baseResponse!.data?.current_page);

            self.restrictSuccessHandler?(baseResponse);
        })
        return self;
    }
    @discardableResult func path(_ path:String) -> Self{
        self.paginator!.path=path;
        return self;
    }
    public func setRefreshHandler (_ refreshHandler:@escaping GeneralListConstant.Handlers.RefreshHnadler){
        self.refreshHandler=refreshHandler;
    }
    @discardableResult  func requestMethod(_ requestMethod:HTTPMethod) ->Self{
        self.paginator?.requestMethod( requestMethod);
        return self;
    }
}

