//
//  GeneralCollectionView.swift
//  NewLineTemplate
//
//  Created by Salah on 7/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import Foundation


import UIKit
import RxSwift
import RxCocoa
import Alamofire
import UIScrollView_InfiniteScroll


class AbstractCollectionView: UICollectionView {
    var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil
    
    typealias Converter = (BaseResponse) ->[Any];
    typealias RefreshHnadler = () ->Void;
    
    public var objects:Variable<[Any]>=Variable<[Any]>([]);
    
    var paginator:PagainatorManager<BaseResponse>?
    var refreshHandler:RefreshHnadler?
    
    var converter:Converter?
    public func start(){
        self.objects.value.removeAll();
        self.refreshControl?.beginRefreshing()
        self.paginator?.start();
    }
    
    @discardableResult public func setup()->Self{
        paginator=PagainatorManager.init();
        self.addInfiniteScroll { (collectionView:UICollectionView) in
            self.loadMore();
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        self.refreshControl?.tintColor = UIColor.black;
        let offsetPoint = CGPoint.init(x: 0, y: -refreshControl!.frame.size.height)
        self.setContentOffset(offsetPoint, animated: true)
        self.paginator?.currentPageKey("page");
        self.paginator?.perPageKey("i_per_pages")
        return self;
    }
    
    @objc func performToPullToRefresh(){
        self.refreshControl?.beginRefreshing();
        self.objects.value.removeAll();
        self.paginator?.start();
        self.refreshHandler?()
    }
    @discardableResult func paramter(value:String,key:String) -> Self{
        self.paginator?.parameter(value: value, key: key)
        return self;
    }
    @discardableResult func converter(_ converter:@escaping Converter) -> Self{
        self.converter = converter;
        return self;
    }
    
    @discardableResult func build() -> Self{
        //     self.paginator?.perPage=15;
        self.paginator?.restrictErrorHandler({ (baseResponse:BaseResponse?,error:Error?) in
            self.defaultFailurePaginatorCompletionHandler();
            
            self.restrictErrorHandler?(baseResponse,error);
        })
        self.paginator?.restrictSuccessHandler({ (baseResponse:BaseResponse?) in
            self.defaultSuccessHandler(paginator: self.paginator, objects:self.converter!(baseResponse!), index: baseResponse?.data?.current_page);
            
            self.restrictSuccessHandler?(baseResponse);
        })
        return self;
    }
    @discardableResult func path(_ path:String) -> Self{
        self.paginator!.path=path;
        return self;
    }
    public func setRefreshHandler (_ refreshHandler:@escaping RefreshHnadler){
        self.refreshHandler=refreshHandler;
    }
    
    @discardableResult  func requestMethod(_ requestMethod:HTTPMethod) ->Self{
        self.paginator?.requestMethod( requestMethod);
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
    private func defaultSuccessHandler(paginator:PagainatorManager<BaseResponse>?, objects:[Any]?, index:Int?){
        if index==1{
            // pull to refresh
            self.objects.value.removeAll();
        }
        print(index);
        self.objects.value += objects!;
        //.reversed()
        // refreshView
        if(self.refreshControl?.isRefreshing ?? false)
        { // pull to refresh
            self.refreshControl?.endRefreshing()
        }
        
        if self.isAnimatingInfiniteScroll {
            // load more
            self.finishInfiniteScroll();
        }
        
    }
}
