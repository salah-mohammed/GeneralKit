//
//  MultiCellCollectionManager.swift
//  GraduationProject
//
//  Created by Salah on 10/9/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import UIKit
import RxCocoa
import Alamofire
import RxCocoa
import RxSwift
class CollectionViewObject :NSObject
{
    var identifier:String="";
    var object :Any?;
    var size:CGSize?
    
    init(identifier:String,object :Any?,size:CGSize?) {
        self.identifier=identifier
        self.object=object;
        self.size = size;
    }
    
    
}
protocol CollectionViewCellProtocol {
    var row: Int! {get set}
    var object: Any! {get set}
    func config(_ collectionView:UICollectionView,_ row:Int,_ object:CollectionViewObject,_ tableManager:MultiCellCollectionManager)
    func itemSelected(_ collectionView:UICollectionView,_ row:Int,_ object:CollectionViewObject,_ tableManager:MultiCellCollectionManager)
}

class MultiCellCollectionManager: NSObject {
    var restrictSuccessHandler: RequestOperationBuilder.RestrictSuccessHandler? = nil
    var restrictErrorHandler: RequestOperationBuilder.RestrictErrorHandler? = nil
    
    typealias Converter = (BaseResponse) ->[Any];
    typealias HandleObject = (Any) ->CollectionViewObject;
    
    var handleObject:HandleObject?;
    typealias RefreshHnadler = () ->Void;
    
    public var objects:Variable<[CollectionViewObject]>=Variable<[CollectionViewObject]>([]);
    let disposeBag = DisposeBag()
    
    public var collectionView:UICollectionView!
    public var viewController:UIViewController?
    
    
    
    
    init(viewController:UIViewController,objects:[CollectionViewObject]?,collectionView:UICollectionView) {
        super.init();
        self.viewController=viewController;
        if objects != nil {
            self.objects=Variable<[CollectionViewObject]>(objects!);
        }
        self.collectionView=collectionView;
        
        self.setup();
    }
    
    
    func append(_ object:CollectionViewObject)
    {
        self.objects.value.append(object);
    }
    
    
    
    
    
    
    var paginator:PagainatorManager?
    var refreshHandler:RefreshHnadler?
    
    var converter:Converter?
    public func start(){
        self.objects.value.removeAll();
        (self.collectionView.backgroundView as! UIRefreshControl).beginRefreshing()
        self.paginator?.start();
    }
    
    public func setup(){
        paginator=PagainatorManager.init();
        self.collectionView.addInfiniteScroll { (collectionView:UICollectionView) in
            self.loadMore();
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(performToPullToRefresh), for: .valueChanged)
        self.collectionView.backgroundView = refreshControl
        self.collectionView.backgroundView!.tintColor = UIColor.black;
        
        self.paginator?.currentPageKey("page");
        self.paginator?.perPageKey("i_per_pages")
    }
    func setupView(){
        
        
        self.objects.asObservable().bind(to: self.collectionView.rx.items){ collectionView, row, group in
            let indexPath = IndexPath(row: row, section: 0)
            var cell =  self.collectionView.dequeueReusableCell(withReuseIdentifier:self.objects.value[row].identifier, for: indexPath) as! CollectionViewCellProtocol;
            cell.config(collectionView, row,self.objects.value[row], self);
            return cell as! UICollectionViewCell ;
            }.disposed(by: disposeBag);
        
        
        
        self.collectionView.rx.itemSelected.asControlEvent().subscribe { (event:Event<IndexPath>) in
            var cell =  self.collectionView.cellForItem(at: event.element!) as! CollectionViewCellProtocol
            
            cell.itemSelected(self.collectionView,event.element!.row, self.objects.value[event.element!.row], self);


            }.disposed(by: disposeBag);
        

    }
    
    private func loadMore()
    {
        
        if ((self.paginator?.isLoading==false)&&(self.paginator?.hasNextPage)!){
            self.paginator?.loadNextPage();
        }
        else{
            
            self.collectionView.finishInfiniteScroll();
        }
        
    }
    
    @objc func performToPullToRefresh(){
        (self.collectionView.backgroundView as! UIRefreshControl).beginRefreshing();
        self.objects.value.removeAll();
        self.paginator?.start();
        self.refreshHandler?()
        
        
        
    }
    
    
    private func defaultFailurePaginatorCompletionHandler()
    {
        if(self.collectionView.backgroundView  != nil && (self.collectionView.backgroundView as! UIRefreshControl).isRefreshing)
        { // pull to refresh
            (self.collectionView.backgroundView as! UIRefreshControl).endRefreshing()
        }
        
        if self.collectionView.isAnimatingInfiniteScroll {
            // load more
            self.collectionView.finishInfiniteScroll();
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
        
        if(self.collectionView.backgroundView  != nil && (self.collectionView.backgroundView as! UIRefreshControl).isRefreshing)
        { // pull to refresh
            (self.collectionView.backgroundView as! UIRefreshControl).endRefreshing()
        }
        
        if self.collectionView.isAnimatingInfiniteScroll {
            // load more
            self.collectionView.finishInfiniteScroll();
        }
        
    }
    
    @discardableResult func paramter(value:String,key:String) -> MultiCellCollectionManager
    {
        
        self.paginator?.parameter(value: value, key: key)
        return self;
    }
    @discardableResult func converter(_ converter:@escaping Converter) -> MultiCellCollectionManager
    {
        self.converter = converter;
        return self;
        
    }
    
    @discardableResult func build() ->MultiCellCollectionManager
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
    
    @discardableResult func path(_ path:String) -> MultiCellCollectionManager
    {
        self.paginator!.path=path;
        return self;
    }
    public func setRefreshHandler (_ refreshHandler:@escaping RefreshHnadler)
    {
        self.refreshHandler=refreshHandler;
    }
    
    @discardableResult func requestMethod(_ requestMethod:HTTPMethod)->MultiCellCollectionManager
    {
        self.paginator?.requestMethod( requestMethod);
        return self;
    }
    @discardableResult func setHandleObject(_ handleObject:@escaping HandleObject)->MultiCellCollectionManager
    {
        self.handleObject = handleObject;
        return self;
    }

}
