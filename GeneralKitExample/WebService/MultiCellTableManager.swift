//
//  MultiCellTableManager.swift
//  GraduationProject
//
//  Created by Salah on 9/21/18.
//  Copyright © 2018 Salah. All rights reserved.


import UIKit
import RxSwift
import RxCocoa
import Alamofire

class TableViewObject :NSObject
{
    var identifier:String="";
    var object :Any?;


    init(identifier:String,object :Any?,height:CGFloat?) {
        self.identifier=identifier
        self.object=object;

    }


}

protocol TableViewCellProtocol {
    var row: Int! {get set}
    var object: Any! {get set}
    func config(_ tableView:UITableView,_ row:Int,_ object:TableViewObject,_ tableManager:MultiCellTableManager)
    func itemSelected(_ tableView:UITableView,_ row:Int,_ object:TableViewObject,_ tableManager:MultiCellTableManager)
}

class MultiCellTableManager: NSObject {
    var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil
    
    typealias Converter = (BaseResponse) ->[Any];
    typealias HandleObject = (Any) ->TableViewObject;

    var handleObject:HandleObject?;
    typealias RefreshHnadler = () ->Void;
    
    public var objects:Variable<[TableViewObject]>=Variable<[TableViewObject]>([]);
    let disposeBag = DisposeBag()

    public var tableView:UITableView!
    public var viewController:UIViewController?




    init(viewController:UIViewController,objects:[TableViewObject]?,tableView:UITableView) {
        super.init();
        self.viewController=viewController;
        if objects != nil {
            self.objects=Variable<[TableViewObject]>(objects!);
        }
        self.tableView=tableView;

        self.setup();
    }


    func append(_ object:TableViewObject)
    {
        self.objects.value.append(object);
    }




    
    
    var paginator:PagainatorManager?
    var refreshHandler:RefreshHnadler?
    
    var converter:Converter?
    public func start(){
        self.objects.value.removeAll();
        (self.tableView.backgroundView as! UIRefreshControl).beginRefreshing()
        self.paginator?.start();
    }
    
    public func setup(){
        paginator=PagainatorManager.init();
        self.tableView.addInfiniteScroll { (tableView:UITableView) in
            self.loadMore();
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
        self.tableView.backgroundView = refreshControl
        self.tableView.backgroundView!.tintColor = UIColor.black;
        
        self.paginator?.currentPageKey("page");
        self.paginator?.perPageKey("i_per_pages")
    }
    func setupView(){
        self.objects.asObservable().bind(to:self.tableView.rx.items) { tableView, row, group in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.dequeueReusableCell(withIdentifier:self.objects.value[row].identifier, for: indexPath) as! TableViewCellProtocol
            cell.config(self.tableView, row, self.objects.value[row], self);
            return cell as! UITableViewCell
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.asControlEvent().subscribe { (event:Event<IndexPath>) in
            self.tableView.deselectRow(at: event.element!, animated: true);
            let cell = self.tableView.cellForRow(at: event.element!) as! TableViewCellProtocol
            cell.itemSelected(self.tableView,event.element!.row, self.objects.value[event.element!.row], self);
            }.disposed(by: disposeBag);
    }
    
    private func loadMore()
    {
        
        if ((self.paginator?.isLoading==false)&&(self.paginator?.hasNextPage)!){
            self.paginator?.loadNextPage();
        }
        else{
            
            self.tableView.finishInfiniteScroll();
        }
        
    }
    
    @objc func performToPullToRefresh(){
        (self.tableView.backgroundView as! UIRefreshControl).beginRefreshing();
        self.objects.value.removeAll();
        self.paginator?.start();
        self.refreshHandler?()
        
        
        
    }
    
    
    private func defaultFailurePaginatorCompletionHandler()
    {
        if(self.tableView.backgroundView  != nil && (self.tableView.backgroundView as! UIRefreshControl).isRefreshing)
        { // pull to refresh
            (self.tableView.backgroundView as! UIRefreshControl).endRefreshing()
        }
        
        if self.tableView.isAnimatingInfiniteScroll {
            // load more
            self.tableView.finishInfiniteScroll();
        }
    }
    
    private func defaultSuccessHandler(paginator:PagainatorManager?, objects:[Any]?, index:Int){
        if index==1{
            // pull to refresh
            self.objects.value.removeAll();
        }
        for object in objects ?? [] {
            self.objects.value.append(self.handleObject!(object))
        }

        if(self.tableView.backgroundView  != nil && (self.tableView.backgroundView as! UIRefreshControl).isRefreshing)
        { // pull to refresh
            (self.tableView.backgroundView as! UIRefreshControl).endRefreshing()
        }
        
        if self.tableView.isAnimatingInfiniteScroll {
            // load more
            self.tableView.finishInfiniteScroll();
        }
        
    }
    
    @discardableResult func paramter(value:String,key:String) -> MultiCellTableManager
    {
        
        self.paginator?.parameter(value: value, key: key)
        return self;
    }
    @discardableResult func converter(_ converter:@escaping Converter) -> MultiCellTableManager
    {
        self.converter = converter;
        return self;
        
    }
    
    @discardableResult func build() ->MultiCellTableManager
    {
        
        self.paginator?.restrictErrorHandler({ (baseResponse:BaseResponse?,error:Error?) in
            self.defaultFailurePaginatorCompletionHandler();
            
            self.restrictErrorHandler?(baseResponse,error);
        })
        self.paginator?.restrictSuccessHandler({ (baseResponse:BaseResponse?) in
            self.defaultSuccessHandler(paginator: self.paginator, objects:self.converter!(baseResponse!), index: baseResponse!.data!.current_page);
            
            self.restrictSuccessHandler?(baseResponse);
        })

        return self;
        
    }
    
    @discardableResult func path(_ path:String) -> MultiCellTableManager
    {
        self.paginator!.path=path;
        return self;
    }
    public func setRefreshHandler (_ refreshHandler:@escaping RefreshHnadler)
    {
        self.refreshHandler=refreshHandler;
    }
    
    @discardableResult func requestMethod(_ requestMethod:HTTPMethod)->MultiCellTableManager
    {
        self.paginator?.requestMethod( requestMethod);
        return self;
    }
    @discardableResult func setHandleObject(_ handleObject:@escaping HandleObject)->MultiCellTableManager
    {
        self.handleObject = handleObject;
        return self;
    }


}


