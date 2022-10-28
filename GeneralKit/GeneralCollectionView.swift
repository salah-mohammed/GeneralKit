//
//  GeneralCollectionView.swift
//  GeneralKit
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit

open class GeneralCollectionViewCell:UICollectionViewCell,GeneralListViewCellProtocol {
    public var list: GeneralListViewProrocol!
    public var listViewController: UIViewController?
    public var indexPath: IndexPath!
    public var object: GeneralCellData!{
        return list.objects[indexPath.section][indexPath.row];
    }
    public func itemSelected() {
    }
    public func config(_ list: GeneralListViewProrocol, _ listViewController: UIViewController?, _ indexPath: IndexPath) {
        self.list = list
        self.listViewController=listViewController;
        self.indexPath=indexPath;
        self.config();
    }
    func config(){
    }
}

open class GeneralCollectionView: UICollectionView,GeneralListViewProrocol,GeneralConnection,UICollectionViewDelegate,UICollectionViewDataSource {
    public var selectionHandler: GeneralListConstant.Handlers.SelectionHandler?
    
    public var containsHandler: GeneralListConstant.Handlers.ContainsHandler?
    public var selectionType: SelectionType = .non
    static var global:GeneralListConstant.Global=GeneralListConstant.Global()
    public var errorConnectionData: ListPlaceHolderData?=ListPlaceHolderView.defaultErrorConnectionData;
    public var emptyData: ListPlaceHolderData?=ListPlaceHolderView.defaultEmptyData;
    public var loadingData: ListPlaceHolderData?=ListPlaceHolderView.defaultLoadingData;
    ////////////////////////-

    
    public var enablePagination: Bool=GeneralTableView.global.enablePagination{
        didSet{
            if enablePagination == true {
                self.removeInfiniteScroll()
                self.addInfiniteScroll { (tableView:UICollectionView) in
                    self.loadMore();
                }
            }else{
                self.removeInfiniteScroll()
            }
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
    public var objects:[[GeneralCellData]]=[[GeneralCellData]]([]);
    
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
    ////////////////////////-
    @discardableResult public func setup()->Self{
        self.delegate=self;
        self.dataSource=self;
        let tempEnablePagination = self.enablePagination;
        self.enablePagination=tempEnablePagination;
        let tempEnablePullToRefresh = self.enablePullToRefresh;
        self.enablePullToRefresh=tempEnablePullToRefresh;
        let tempEnableListPlaceHolderView = self.enableListPlaceHolderView;
        self.enableListPlaceHolderView=tempEnableListPlaceHolderView;
        return self;
    }
    open override func awakeFromNib() {
        super.awakeFromNib();
        self.setup()
    }
    ////////////////////////-
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
    ////////////////////////-
    func config(collectionView:UICollectionView,indexPath:IndexPath,object:GeneralCellData)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:object.identifier, for:indexPath) as! GeneralListViewCellProtocol;
        cell.config(self, self.listViewController, indexPath);
        return cell as! UICollectionViewCell;
    }
    func itemSelected(_ indexPath:IndexPath){
        let cell = self.cellForItem(at: indexPath) as! GeneralListViewCellProtocol
        cell.itemSelected();
    }
    ////////////////////////-
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.config(collectionView: collectionView, indexPath: indexPath, object: self.objects[indexPath.section][indexPath.row])
    }
}
