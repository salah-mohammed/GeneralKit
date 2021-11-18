//
//  GeneralTableView.swift
//  Jobs
//
//  Created by Salah on 11/18/18.
//  Copyright © 2018 Salah. All rights reserved.
//
//



import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll
import Alamofire


class GeneralCellData: NSObject {
    var identifier: String = ""
    var object: Any?
    init(identifier: String, object: Any?) {
        super.init()
        self.identifier = identifier
        self.object = object
    }
}

struct ThemeManager {
    
}

class GeneralTableViewCell:UITableViewCell,GeneralListViewCellProtocol {
    var list: GeneralListViewProrocol!
    var listViewController: UIViewController?
    var indexPath: IndexPath!
    var object: GeneralCellData!{return self.list.objects.value[indexPath.row]};

    final func config(_ list:GeneralListViewProrocol,_ listViewController:UIViewController?,_ indexPath:IndexPath){
        self.list = list as! GeneralTableView
        self.listViewController=listViewController;
        self.indexPath=indexPath;
        self.config();
    }
    func config(){
UIView.appearance()
    }
    func itemSelected() {
        
    }
}
class GeneralTableView: UITableView,GeneralListViewProrocol,GeneralConnection {
    static var global:GeneralListConstant.Global=GeneralListConstant.Global()
    var errorConnectionData: ListPlaceHolderData?=ListPlaceHolderView.defaultErrorConnectionData;
    var emptyData: ListPlaceHolderData?=ListPlaceHolderView.defaultEmptyData;
    var loadingData: ListPlaceHolderData?=ListPlaceHolderView.defaultLoadingData;
    
    
    var enablePagination: Bool=GeneralCollectionView.global.enablePagination{
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
    var enableWaitingView:Bool=GeneralTableView.global.enableWaitingView{
        didSet{
            self.paginator?.requestBuilder?.enableWaitingView=enableWaitingView;
        }
    }
    var enableTableProgress:Bool=GeneralTableView.global.enableTableProgress;
    var disposeBag = DisposeBag()
    public var objects:Variable<[GeneralCellData]>=Variable<[GeneralCellData]>([]);

    
    
    var converterHandler: GeneralListConstant.Handlers.ConverterHandler?
    var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil
    var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?
    var routerHandler:GeneralListConstant.Handlers.RouterHandler?
    
    
    var identifier: String?
    var paginator:PagainatorManager<BaseResponse>?
    var listViewController:UIViewController?
    var listPlaceholderView: ListPlaceHolderView?{
        didSet{
            self.backgroundView = listPlaceholderView;
        }
    }
    var enableListPlaceHolderView:Bool=GeneralTableView.global.enableListPlaceHolderView{
        didSet{
            if self.enableListPlaceHolderView {
            //    self.listPlaceholderView=ListPlaceHolderView.loadViewFromNib()
            }else{
                self.listPlaceholderView?.isHidden=true;
                self.listPlaceholderView?.removeFromSuperview();
                self.listPlaceholderView=nil;
            }
        }
    }
    @discardableResult public func setup()->Self{
        paginator=PagainatorManager.init();
        paginator?.requestBuilder?.enableWaitingView=self.enableWaitingView;
        let tempEnablePagination = self.enablePagination;
        self.enablePagination=tempEnablePagination;
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.black;
        self.paginator?.currentPageKey("page");
        self.paginator?.perPageKey("i_per_pages");
        self.setupView();
        
        return self;
    }
    func setupView(){
        let tempEnableListPlaceHolderView = self.enableListPlaceHolderView;
        self.enableListPlaceHolderView=tempEnableListPlaceHolderView;
        self.objects.asObservable().bind(to:self.rx.items) { tableView, row, group in
            let indexPath = IndexPath(row: row, section: 0)
            return self.config(tableView: self, indexPath: indexPath, object: group);
            }.disposed(by: disposeBag)
        self.rx.itemSelected.asControlEvent().subscribe { (event:Event<IndexPath>) in
            self.itemSelected(event);
            }.disposed(by: disposeBag);
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

    func config(tableView:UITableView,indexPath:IndexPath,object:GeneralCellData)->UITableViewCell{
        let object:GeneralCellData = object
        let cell = self.dequeueReusableCell(withIdentifier:object.identifier, for: indexPath) as! GeneralListViewCellProtocol
        cell.config(self,self.listViewController, indexPath)
        return cell as! UITableViewCell
    }
    func itemSelected(_ event:Event<IndexPath>){
        let cell:GeneralListViewCellProtocol =  self.cellForRow(at: event.element!) as! GeneralListViewCellProtocol
        cell.itemSelected();
    }
}
