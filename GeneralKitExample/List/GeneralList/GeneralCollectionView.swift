//
//  GeneralCollectionView.swift
//  Jobs
//
//  Created by Salah on 11/18/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import UIScrollView_InfiniteScroll



protocol GeneralCollectionViewCellProrocol {
    var collectionView:GeneralCollectionView!{ get set}
    var collectionViewController:UIViewController?{ get set}
    var indexPath:IndexPath!{ get set}
    var object:GeneralCellData!{get}
    func config(_ collectionView:GeneralCollectionView,_ collectionViewController:UIViewController?,_ indexPath:IndexPath)
    func itemSelected();
}
class GeneralCollectionView: UICollectionView,GeneralListViewProrocol,GeneralConnection {
    static var global:GeneralListConstant.Global=GeneralListConstant.Global()

    var errorConnectionData: ListPlaceHolderData?=ListPlaceHolderView.defaultErrorConnectionData;
    var emptyData: ListPlaceHolderData?=ListPlaceHolderView.defaultEmptyData;
    var loadingData: ListPlaceHolderData?=ListPlaceHolderView.defaultLoadingData;

    var enablePagination: Bool=GeneralCollectionView.global.enablePagination{
        didSet{
            if enablePagination == true {
                self.removeInfiniteScroll()
                self.addInfiniteScroll { (collectionView:UICollectionView) in
                    self.loadMore();
                }
            }else{
                self.removeInfiniteScroll()
            }
        }
    }
    var enableWaitingView:Bool=GeneralCollectionView.global.enableWaitingView{
        didSet{
            self.paginator?.requestBuilder?.enableWaitingView=enableWaitingView;
        }
    }
    var enableTableProgress: Bool=GeneralCollectionView.global.enableTableProgress;
    
    var enableListPlaceHolderView: Bool=GeneralCollectionView.global.enableListPlaceHolderView{
        didSet{
            if self.enableListPlaceHolderView {
      //       self.listPlaceholderView=ListPlaceHolderView.loadViewFromNib()
            }else{
                self.listPlaceholderView?.isHidden=true;
                self.listPlaceholderView?.removeFromSuperview();
                self.listPlaceholderView=nil;
            }
        }
    }
    
    
    var disposeBag = DisposeBag()
    public var objects:Variable<[GeneralCellData]>=Variable<[GeneralCellData]>([]);

    
    
    var converterHandler: GeneralListConstant.Handlers.ConverterHandler?
    var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil
    var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?
    var routerHandler:GeneralListConstant.Handlers.RouterHandler?

    
    var identifier: String?
    var paginator:PagainatorManager?
    var listViewController:UIViewController?
    var listPlaceholderView: ListPlaceHolderView?{
        didSet{
            self.backgroundView = listPlaceholderView;
        }
    }

    @discardableResult public func setup()->Self{
        let tempEnableListPlaceHolderView = self.enableListPlaceHolderView;
        self.enableListPlaceHolderView=tempEnableListPlaceHolderView;
        paginator=PagainatorManager.init();
        let tempEnablePagination = self.enablePagination;
        self.enablePagination=tempEnablePagination;
        paginator?.requestBuilder?.enableWaitingView=self.enableWaitingView;
         self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        self.refreshControl?.tintColor = UIColor.black;
        
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
    func setupView(){
        self.enableListPlaceHolderView=true;
        self.objects.asObservable().bind(to: self.rx.items){ collectionView, row, group in
            let indexPath = IndexPath(row: row, section: 0)
            return self.config(collectionView: self, indexPath: indexPath, object: group);
            }.disposed(by: disposeBag);
        
        self.rx.itemSelected.asControlEvent().subscribe { (event:Event<IndexPath>) in
            self.itemSelected(event)
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
    func config(collectionView:UICollectionView,indexPath:IndexPath,object:GeneralCellData)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:object.identifier, for:indexPath) as! GeneralCollectionViewCellProrocol;
        cell.config(self, self.listViewController, indexPath);
        return cell as! UICollectionViewCell;
    }
    func itemSelected(_ event:Event<IndexPath>){
        let cell = self.cellForItem(at: event.element!) as! GeneralCollectionViewCellProrocol
        cell.itemSelected();
    }
}
