//
//  GeneralTableView.swift
//  GeneralKit
//
//  Created by SalahMohamed on 17/10/2022.
//

import UIKit

open class GeneralCellData: NSObject {
    var identifier: String = ""
    var object: Any?
    init(identifier: String, object: Any?) {
        super.init()
        self.identifier = identifier
        self.object = object
    }
}
public struct GeneralListConstant {
    public  struct Handlers {
        public typealias ConverterHandler = (Any) ->GeneralCellData;
        public typealias RefreshHnadler = () ->Void;
        public typealias RouterHandler = (BaseModel) ->[Any];
    }
    public  struct Global{
        var enableListPlaceHolderView:Bool=true;
        var enableTableProgress: Bool=true;
        var enableWaitingView: Bool=false
        var enablePagination: Bool=true
    }
   
}
public protocol GeneralListViewCellProtocol:class {
    var list:GeneralListViewProrocol!{ get set}
    var listViewController:UIViewController?{ get set}
    var indexPath:IndexPath!{ get set}
    var object:GeneralCellData!{get}
    func itemSelected();
    func config(_ list:GeneralListViewProrocol,_ listViewController:UIViewController?,_ indexPath:IndexPath)
}
public enum ItemType{
case append([Any])
case replace([Any])
}

public protocol GeneralListViewProrocol:class {
    var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?{get set}
    var routerHandler:GeneralListConstant.Handlers.RouterHandler?{get set}
    var converterHandler:GeneralListConstant.Handlers.ConverterHandler?{get set}
    var responseHandler:RequestOperationBuilder<BaseModel>.FinishHandler?{get set}

    var objects:[GeneralCellData]{ get set}
    var listViewController:UIViewController?{ get set}
    var paginator:PaginationManagerProtocol?{get set}
    var identifier: String?{get set}
    var refreshControl:UIRefreshControl?{get set}
    var enableListPlaceHolderView:Bool{get set}
    var enableTableProgress:Bool{get set}
    var enableWaitingView:Bool{get set}
    var enablePagination:Bool{get set}
    var enablePullToRefresh:Bool{get set}
    var listPlaceholderView: ListPlaceHolderView?{get set}
    var errorConnectionData:ListPlaceHolderData?{get set}
    var emptyData:ListPlaceHolderData?{get set}
    var loadingData:ListPlaceHolderData?{get set}
    func paginationManager(_ paginationManager:PaginationManagerProtocol) -> Self
    func start();
    func reloadData()

}

public protocol GeneralConnection:GeneralListViewProrocol{
    
}
open class GeneralTableViewCell:UITableViewCell,GeneralListViewCellProtocol {
    public var list: GeneralListViewProrocol!
    public var listViewController: UIViewController?
    public var indexPath: IndexPath!
    public var object: GeneralCellData!{return self.list.objects[indexPath.row]};

    final public func config(_ list:GeneralListViewProrocol,_ listViewController:UIViewController?,_ indexPath:IndexPath){
        self.list = list as! GeneralTableView
        self.listViewController=listViewController;
        self.indexPath=indexPath;
        self.config();
    }
    func config(){
    }
    public func itemSelected() {
        
    }
}

open class GeneralTableView: UITableView,GeneralListViewProrocol,GeneralConnection,UITableViewDelegate,UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.config(tableView: self, indexPath: indexPath, object: self.objects[indexPath.row]);
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSelected(indexPath);
    }
    

    static var global:GeneralListConstant.Global=GeneralListConstant.Global()
    public var errorConnectionData: ListPlaceHolderData?=ListPlaceHolderView.defaultErrorConnectionData;
    public var emptyData: ListPlaceHolderData?=ListPlaceHolderView.defaultEmptyData;
    public var loadingData: ListPlaceHolderData?=ListPlaceHolderView.defaultLoadingData;
    
    
    public var enablePagination: Bool=GeneralTableView.global.enablePagination{
        didSet{
            if enablePagination == true {
                self.removeInfiniteScroll()
                self.addInfiniteScroll { (tableView:UITableView) in
                    self.loadMore();
                }
            }else{
                self.removeInfiniteScroll()
            }
        }
    }
    public var enableWaitingView:Bool=GeneralTableView.global.enableWaitingView{
        didSet{
            self.paginator?.showLoader=enableWaitingView;
        }
    }
    public var enablePullToRefresh:Bool=true{
        didSet{
            if enablePullToRefresh==true {
                self.refreshControl = UIRefreshControl()
                self.refreshControl?.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
                self.refreshControl = refreshControl
                self.refreshControl?.tintColor = UIColor.black;
            }else{
                self.refreshControl = nil;
            }
        }
    }
    public var enableTableProgress:Bool=GeneralTableView.global.enableTableProgress;
    public var objects:[GeneralCellData]=[GeneralCellData]([]);

    
    public var converterHandler: GeneralListConstant.Handlers.ConverterHandler?
    public var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?
    public var routerHandler:GeneralListConstant.Handlers.RouterHandler?
    
    
    public var identifier: String?
    public var paginator:PaginationManagerProtocol?
    public var responseHandler:RequestOperationBuilder<BaseModel>.FinishHandler?
    public var listViewController:UIViewController?
    public var listPlaceholderView: ListPlaceHolderView?{
        didSet{
            self.backgroundView = listPlaceholderView;
        }
    }
    public var enableListPlaceHolderView:Bool=GeneralTableView.global.enableListPlaceHolderView{
        didSet{
            if self.enableListPlaceHolderView {
                self.listPlaceholderView=ListPlaceHolderView.loadViewFromNib()
            }else{
                self.listPlaceholderView?.isHidden=true;
                self.listPlaceholderView?.removeFromSuperview();
                self.listPlaceholderView=nil;
            }
        }
    }
    @discardableResult public func setup()->Self{
        self.delegate=self;
        self.dataSource=self;
//        paginator?.requestBuilder?.enableWaitingView=self.enableWaitingView;
        let tempEnablePagination = self.enablePagination;
        self.enablePagination=tempEnablePagination;
        let tempEnablePullToRefresh = self.enablePullToRefresh;
        self.enablePullToRefresh=tempEnablePullToRefresh;
        self.setupView();
//        self.relam = try? Realm();

        return self;
    }
    open override func awakeFromNib() {
        super.awakeFromNib();
        self.setup()
    }
    func setupView(){
        let tempEnableListPlaceHolderView = self.enableListPlaceHolderView;
        self.enableListPlaceHolderView=tempEnableListPlaceHolderView;

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
        self.objects.removeAll();
        self.paginator?.start();
        self.refreshHandler?()
    }

    func config(tableView:UITableView,indexPath:IndexPath,object:GeneralCellData)->UITableViewCell{
        let object:GeneralCellData = object
        let cell = self.dequeueReusableCell(withIdentifier:object.identifier, for: indexPath) as! GeneralListViewCellProtocol
        cell.config(self,self.listViewController, indexPath)
        return cell as! UITableViewCell
    }
    func itemSelected(_ indexPath:IndexPath){
        if let cell:GeneralListViewCellProtocol = self.cellForRow(at:indexPath) as? GeneralListViewCellProtocol{
            cell.itemSelected();
        }
    }
}

extension GeneralListViewProrocol where Self: GeneralConnection {
    @discardableResult public func paginationManager(_ paginationManager:PaginationManagerProtocol) -> Self {
        self.paginator=paginationManager
        return self
    }
    @discardableResult public func listViewController(_ listViewController:UIViewController) -> Self{
        self.listViewController = listViewController;
        return self;
    }
    @discardableResult public func routerHandler(_ routerHandler:@escaping GeneralListConstant.Handlers.RouterHandler) -> Self{
        self.routerHandler = routerHandler;
        return self;
    }
    @discardableResult public func converterHandler(_ converterHandler:@escaping GeneralListConstant.Handlers.ConverterHandler) -> Self{
        self.converterHandler = converterHandler;
        return self;
    }
    @discardableResult public  func refreshHandler (_ refreshHandler:@escaping GeneralListConstant.Handlers.RefreshHnadler) -> Self
    {
        self.refreshHandler=refreshHandler;
        return self;
    }
    @discardableResult public func responseHandler (_ refreshHandler:@escaping RequestOperationBuilder<BaseModel>.FinishHandler) -> Self
    {
        self.responseHandler=responseHandler;
        return self;
    }
    @discardableResult public func identifier(_ identifier:String) -> Self
    {
        self.identifier=identifier;
        return self;
    }
    @discardableResult public func build() -> Self
    {
        self.listPlaceholderView?.refreshCompletionHandler({ (currentData) in
            if self.errorConnectionData == currentData {
                self.start();
            }
        })
//        self.paginator?.responseHandler({ a in
//            self.responseHandler?(a);
//            if let error:Error = a.error{
//            self.defaultFailurePaginatorCompletionHandler(error:error);
//            }else{
//            self.defaultSuccessHandler(paginator: self.paginator, objects:self.routerHandler?(a.value!) ?? []);
//            }
//        })
        return self;
    }
//    private func defaultFailurePaginatorCompletionHandler(error:Error?)
//    {
//        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
//        self.handlePlaceHolderViewConnectionError(error: error, enableListPlaceHolderView: self.enableListPlaceHolderView);
//
//            if(self.refreshControl?.isRefreshing ?? false){
//                self.refreshControl?.endRefreshing()
//            }
//        if let scrollview:UIScrollView = self as? UIScrollView {
//            if scrollview.isAnimatingInfiniteScroll {
//                // load more
//                scrollview.finishInfiniteScroll();
//            }
//        }
//
//    }
    public func handle(itemsType:ItemType){
        switch itemsType{
        case .append(let items):
            self.objects.append(contentsOf:items.map({GeneralCellData.init(identifier:self.identifier ?? "", object: $0)}));
            break;
        case .replace(let items):
            self.objects=items.map({GeneralCellData.init(identifier:self.identifier ?? "", object: $0)})
            self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
            self.handlePlaceHolderViewEmptyData(objects: objects, enableListPlaceHolderView: self.enableListPlaceHolderView)
            break;
        }
        self.reloadData()
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
//    private func defaultSuccessHandler(paginator:PaginationManagerProtocol?, objects:[Any]?){
//        let index = paginator?.UICurrentPage
//        if index==1{
//            // pull to refresh
//        self.objects.removeAll();
//        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
//        self.handlePlaceHolderViewEmptyData(objects: objects, enableListPlaceHolderView: self.enableListPlaceHolderView)
//        }
//        var tempObjects:[GeneralCellData] = []
//        for object in objects ?? [] {
//            tempObjects.append(self.converterHandler?(object) ?? GeneralCellData.init(identifier: self.identifier!, object: object));
//        }
//        self.objects += tempObjects;
//        if(self.refreshControl?.isRefreshing ?? false){
//            self.refreshControl?.endRefreshing()
//        }
//        if let scrollview:UIScrollView = self as? UIScrollView {
//            if scrollview.isAnimatingInfiniteScroll {
//                // load more
//                scrollview.finishInfiniteScroll();
//            }
//        }
//    }
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
    public func start(){
        self.objects.removeAll();
        self.handlePlaceHolderViewLoading(start:true,enableListPlaceHolderView:self.enableListPlaceHolderView);
        if self.enableTableProgress{
            self.refreshControl?.beginRefreshing()
        }
        self.paginator?.start();
    }
}
