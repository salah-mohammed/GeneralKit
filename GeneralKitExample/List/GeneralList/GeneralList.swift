//
//  General.swift
//  Jobs
//
//  Created by Salah on 11/23/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol GeneralConnection:GeneralListViewProrocol{
    
}
struct GeneralListConstant {
    public  struct Handlers {
        typealias ConverterHandler = (Any) ->GeneralCellData;
        typealias RefreshHnadler = () ->Void;
        typealias RouterHandler = (BaseResponse) ->[Any];
    }
    public  struct Global{
        var enableListPlaceHolderView:Bool=true;
        var enableTableProgress: Bool=true;
        var enableWaitingView: Bool=false
        var enablePagination: Bool=true

    }
}
protocol GeneralListViewProrocol:class {
    var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?{get set}
    var routerHandler:GeneralListConstant.Handlers.RouterHandler?{get set}
    var converterHandler:GeneralListConstant.Handlers.ConverterHandler?{get set}
    var restrictSuccessHandler: RequestOperationBuilder<BaseResponse>.RestrictSuccessHandler? {get set}
    var restrictErrorHandler: RequestOperationBuilder<BaseResponse>.RestrictErrorHandler?{get set}
    var listPlaceholderView: ListPlaceHolderView?{get set}
    var objects:Variable<[GeneralCellData]>{ get set}
    var listViewController:UIViewController?{ get set}
    var paginator:PagainatorManager<BaseResponse>?{get set}
    var identifier: String?{get set}
    var refreshControl:UIRefreshControl?{get set}
    var enableListPlaceHolderView:Bool{get set}
    var enableTableProgress:Bool{get set}
    var enableWaitingView:Bool{get set}
    var enablePagination:Bool{get set}
    var errorConnectionData:ListPlaceHolderData?{get set}
    var emptyData:ListPlaceHolderData?{get set}
    var loadingData:ListPlaceHolderData?{get set}

    func path(_ path:String) -> Self
    func paramter(value:String,key:String) -> Self
    func start();
    func reloadData()
    

}
protocol GeneralListViewCellProtocol:class {
    var list:GeneralListViewProrocol!{ get set}
    var listViewController:UIViewController?{ get set}
    var indexPath:IndexPath!{ get set}
    var object:GeneralCellData!{get}
    func itemSelected();
    func config(_ list:GeneralListViewProrocol,_ listViewController:UIViewController?,_ indexPath:IndexPath)
}


extension GeneralListViewProrocol where Self: GeneralConnection {
    
    @discardableResult func listViewController(_ listViewController:UIViewController) -> Self{
        self.listViewController = listViewController;
        return self;
    }
    @discardableResult func path(_ path:String) -> Self{
        self.paginator!.path=path;
        return self;
    }
    @discardableResult func identifier(_ identifier:String) -> Self{
        self.identifier=identifier;
        return self;
    }
    @discardableResult func paramter(value:String,key:String) -> Self{
        self.paginator?.parameter(value: value, key: key)
        return self;
    }
    @discardableResult  func requestMethod(_ requestMethod:HTTPMethod) ->Self{
        self.paginator?.requestMethod( requestMethod);
        return self;
    }
    @discardableResult func routerHandler(_ routerHandler:@escaping GeneralListConstant.Handlers.RouterHandler) -> Self{
        self.routerHandler = routerHandler;
        return self;
    }
    @discardableResult func converterHandler(_ converterHandler:@escaping GeneralListConstant.Handlers.ConverterHandler) -> Self{
        self.converterHandler = converterHandler;
        return self;
    }
    @discardableResult  func refreshHandler (_ refreshHandler:@escaping GeneralListConstant.Handlers.RefreshHnadler) -> Self
    {
        self.refreshHandler=refreshHandler;
        return self;
    }
    @discardableResult func build() -> Self
    {
        //     self.paginator?.perPage=15;
        self.listPlaceholderView?.refreshCompletionHandler({ (currentData) in
            if self.errorConnectionData == currentData {
                self.start();
            }
        })
        self.paginator?.restrictErrorHandler({ (baseResponse:BaseResponse?,error:Error?) in
            self.defaultFailurePaginatorCompletionHandler(error:error);
            
            self.restrictErrorHandler?(baseResponse,error);
        })
        self.paginator?.restrictSuccessHandler({ (baseResponse:BaseResponse?) in
            DebugError.debug(debug: self.routerHandler);
            self.defaultSuccessHandler(paginator: self.paginator, objects:self.routerHandler!(baseResponse!), index: baseResponse?.data?.current_page);
            
            self.restrictSuccessHandler?(baseResponse);
        })
        return self;
    }
    private func defaultFailurePaginatorCompletionHandler(error:Error?)
    {
        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
        self.handlePlaceHolderViewConnectionError(error: error, enableListPlaceHolderView: self.enableListPlaceHolderView);

            if(self.refreshControl?.isRefreshing ?? false){
                self.refreshControl?.endRefreshing()
            }
        if let scrollview:UIScrollView = self as? UIScrollView {
            if scrollview.isAnimatingInfiniteScroll {
                // load more
                scrollview.finishInfiniteScroll();
            }
        }
        
    }
    
    private func defaultSuccessHandler(paginator:PagainatorManager<BaseResponse>?, objects:[Any]?, index:Int?){
        if index==1{
            // pull to refresh
            self.objects.value.removeAll();
        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
        self.handlePlaceHolderViewEmptyData(objects: objects, enableListPlaceHolderView: self.enableListPlaceHolderView)
        }
        var tempObjects:[GeneralCellData] = []
        DebugError.debug(debug: self.converterHandler);
        for object in objects ?? [] {
            tempObjects.append(self.converterHandler?(object) ?? GeneralCellData.init(identifier: self.identifier!, object: object));
        }
        self.objects.value += tempObjects;
        if(self.refreshControl?.isRefreshing ?? false){
            self.refreshControl?.endRefreshing()
        }
        if let scrollview:UIScrollView = self as? UIScrollView {
            if scrollview.isAnimatingInfiniteScroll {
                // load more
                scrollview.finishInfiniteScroll();
            }
        }
        
        
    }
    func handlePlaceHolderViewEmptyData (objects:[Any]?,enableListPlaceHolderView:Bool){
        if enableListPlaceHolderView {
        if objects?.count ?? 0 == 0 {
            self.listPlaceholderView?.isHidden=false
            self.listPlaceholderView?.currentPlaceHolder=self.emptyData;
        }else{
            self.listPlaceholderView?.isHidden=true
            
        }
        }
    }
    func handlePlaceHolderViewConnectionError(error:Error?,enableListPlaceHolderView:Bool){
        if enableListPlaceHolderView {
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet{
            self.listPlaceholderView?.isHidden=false;
            self.listPlaceholderView?.currentPlaceHolder=self.errorConnectionData;

        }else{
            self.listPlaceholderView?.isHidden=true;
        }
        }
    }
    func handlePlaceHolderViewLoading(start:Bool,enableListPlaceHolderView:Bool){
        if enableListPlaceHolderView {
            if start {
            self.listPlaceholderView?.isHidden=false;
            self.listPlaceholderView?.currentPlaceHolder=self.loadingData;
            }else{
                self.listPlaceholderView?.isHidden=true;
            }
        }else{
            self.listPlaceholderView?.isHidden=true;
        }
    }
    func refreshHandler (_ refreshHandler:@escaping GeneralListConstant.Handlers.RefreshHnadler)
    {
        self.refreshHandler=refreshHandler;
    }
    func start(){
        
        self.objects.value.removeAll();
        self.handlePlaceHolderViewLoading(start:true,enableListPlaceHolderView:self.enableListPlaceHolderView);
        if self.enableTableProgress{
            self.refreshControl?.beginRefreshing()
        }
        self.paginator?.start();
    }
    
}
