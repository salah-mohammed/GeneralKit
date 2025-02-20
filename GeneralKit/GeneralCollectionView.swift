//
//  GeneralCollectionView.swift
//  GeneralKit
//
//  Created by SalahMohamed on 24/10/2022.
//
#if os(iOS)

import UIKit

@objc public protocol GeneralCollectionViewCellProtocol{
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}
open class GeneralCollectionViewCell:UICollectionViewCell,GeneralListViewCellProtocol,GeneralCollectionViewCellProtocol {
    // MARK: - GeneralListViewProrocol
    weak public var list: GeneralListViewProrocol?
    weak public var listViewController: UIViewController?
    public var object: GeneralCellData?{
        if let indexPath:IndexPath = self.indexPath{
            return list?.objects.bs_get(indexPath.section)?.bs_get(indexPath.row);
        }
        return nil;
    }
    public var indexPath: IndexPath?{
        return self.list?.indexPathForItemInList(at: self.center)
    }
    open func itemSelected(_ indexPath:IndexPath,
                           _ data: GeneralCellData?) {
    }
    open func config(_ indexPath: IndexPath,
                     _ data:GeneralCellData?) {

    }
    // MARK: - GeneralCollectionViewCellProtocol
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
    }
}

open class GeneralCollectionView: UICollectionView,GeneralListViewProrocol,GeneralConnection,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    public static var global:GeneralListConstant.Global=GeneralListConstant.global
    public var errorConnectionView: ListPlaceHolder?=global.errorConnectionDataViewHandler?()
    public var emptyDataView: ListPlaceHolder?=global.emptyDataViewHandler?()
    public var loadingDataView: ListPlaceHolder?=global.loadingDataHandler?()
    ////////////////////////-

    private var itemSize:CGSize?
    @discardableResult public func itemSize(_ itemSize:CGSize)->Self{
    self.itemSize=itemSize;
      return self
    }
 
//    var elementKindSectionHeaderIdentifire:String?
//    public func elementKindSectionHeaderIdentifire(_ elementKindSectionHeaderIdentifire:String)->Self{
//    self.elementKindSectionHeaderIdentifire=elementKindSectionHeaderIdentifire;
//      return self
//    }
//    var  elementKindSectionFooterIdentifire:String?
//    public func elementKindSectionFooterIdentifire(_ elementKindSectionFooterIdentifire:String)->Self{
//    self.elementKindSectionFooterIdentifire=elementKindSectionFooterIdentifire;
//      return self
//    }
    var footerSize:CGSize?
    @discardableResult public func footerSize(_ footerSize:CGSize)->Self{
    self.footerSize=footerSize;
      return self
    }
    var headerSize:CGSize?
    @discardableResult public func headerSize(_ headerSize:CGSize)->Self{
    self.headerSize=headerSize;
      return self
    }
    
    var footerSizeHandler:((Int)->CGSize)?
    public func footerSizeHandler(_ footerSizeHandler:@escaping ((Int)->CGSize))->Self{
    self.footerSizeHandler=footerSizeHandler;
      return self
    }
    var headerSizeHandler:((Int)->CGSize)?
    @discardableResult public func headerSizeHandler(_ headerSizeHandler:@escaping ((Int)->CGSize))->Self{
    self.headerSizeHandler=headerSizeHandler;
      return self
    }
    private var viewForSupplementaryElementHandler:GeneralListConstant.Handlers.ViewForSupplementaryElementHandler?
    @discardableResult public func viewForSupplementaryElementHandler(_ handler:GeneralListConstant.Handlers.ViewForSupplementaryElementHandler?)->Self{
    self.viewForSupplementaryElementHandler=handler;
      return self
    }
//    private var viewForSupplementaryFooterElementHandler:GeneralListConstant.Handlers.ViewForSupplementaryElementHandler?
//    public func viewForSupplementaryFooterElementHandler(_ handler:GeneralListConstant.Handlers.ViewForSupplementaryElementHandler?)->Self{
//    self.viewForSupplementaryFooterElementHandler=handler;
//      return self
//    }
//    private var viewForSupplementaryHeaderElementHandler:GeneralListConstant.Handlers.ViewForSupplementaryElementHandler?
//    public func viewForSupplementaryHeaderElementHandler(_ handler:GeneralListConstant.Handlers.ViewForSupplementaryElementHandler?)->Self{
//    self.viewForSupplementaryHeaderElementHandler=handler;
//      return self
//    }
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
    public var objects:[[GeneralCellData]]=[[GeneralCellData]]()

    public var converterHandler: GeneralListConstant.Handlers.ConverterHandler?
    public var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?
    public var routerHandler:GeneralListConstant.Handlers.RouterHandler?
    public var selectionHandler: GeneralListConstant.Handlers.SelectionHandler?
    public var containsHandler: GeneralListConstant.Handlers.ContainsHandler?
    
    public var selectionType: SelectionType = .non
    public var identifier: String?
    weak public var paginator:PaginationManagerProtocol?
    weak public var listViewController:UIViewController?
    public var enableListPlaceHolderView:Bool=GeneralTableView.global.enableListPlaceHolderView{
        didSet{
            if self.enableListPlaceHolderView {
            }else{
                self.backgroundView?.removeFromSuperview()
                self.backgroundView=nil;
            }
        }
    }
    ////////////////////////-
    @discardableResult private func setup()->Self{
        self.listViewController = self.bs_getParentViewController()
        self.delegate=self;
        self.dataSource=self;
        let tempEnablePagination = self.enablePagination;
        self.enablePagination=tempEnablePagination;
        let tempEnablePullToRefresh = self.enablePullToRefresh;
        self.enablePullToRefresh=tempEnablePullToRefresh;
        let tempEnableListPlaceHolderView = self.enableListPlaceHolderView;
        self.enableListPlaceHolderView=tempEnableListPlaceHolderView;
        viewsSetup();
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
        let sectionCount = self.objects.count
        self.refreshControl?.beginRefreshing();
        self.objects.removeAll();
        let indexSet = IndexSet.init(integersIn: 0...sectionCount-1)
        self.deleteSections(indexSet);
        self.paginator?.start();
        self.refreshHandler?()
    }
    ////////////////////////-
    func config(collectionView:UICollectionView,indexPath:IndexPath,object:GeneralCellData?)->UICollectionViewCell{
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier:object?.identifier ?? "", for:indexPath) as! GeneralListViewCellProtocol;
        cell.list = self;
        cell.listViewController = self.listViewController
        cell.config(indexPath,object);
        return cell as! UICollectionViewCell;
    }
    func itemSelected(_ indexPath:IndexPath){
        let cell = self.cellForItem(at: indexPath) as! GeneralListViewCellProtocol
        cell.itemSelected(indexPath,self.objects.bs_get(indexPath.section)?.bs_get(indexPath.row))
    }
    ////////////////////////-
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.bs_get(section)?.count ?? 0;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.config(collectionView: collectionView, indexPath: indexPath, object: self.objects[indexPath.section][indexPath.row])
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.objects.count
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.objects.bs_get(indexPath.section)?.bs_get(indexPath.row)?.cellSize ?? self.itemSize ?? CGSize(width:1, height:1);
        return size
    }
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var internalView:UICollectionReusableView?
//        if  kind == UICollectionView.elementKindSectionHeader{
//        internalView = self.viewForSupplementaryHeaderElementHandler?(kind,indexPath);
//        }else
//        if kind == UICollectionView.elementKindSectionFooter
//        {
//        internalView = self.viewForSupplementaryFooterElementHandler?(kind,indexPath);
//        }
        return  internalView ?? viewForSupplementaryElementHandler?(kind,indexPath) ?? UICollectionReusableView()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.headerSizeHandler?(section) ?? self.headerSize ?? CGSize.zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.footerSizeHandler?(section) ?? self.footerSize ?? CGSize.zero
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.itemSelected(indexPath);
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? GeneralCollectionViewCellProtocol)?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? GeneralCollectionViewCellProtocol)?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    // MARK: - UI
    public func insertInList(indexPaths:[IndexPath]){
        self.performBatchUpdates({ () -> Void in
            self.insertItems(at:indexPaths)
        }, completion: nil)
    }
    public func reloadRowInList(indexPaths:[IndexPath]){
        self.reloadItems(at: indexPaths);
    }
    public func reloadSectionsInList(_ indexSet: IndexSet) {
        self.reloadSections(indexSet);
    }
    public func deleteRowsInList(_ indexPath:[IndexPath]){
        self.deleteItems(at: indexPath)
    }
    public func insertSectionsInList(sections:IndexSet){
        self.insertSections(sections);
    }
    public func indexPathForItemInList(at point: CGPoint)->IndexPath?{
        return self.indexPathForItem(at: point);
    }
    public func listHeaderView(forSection: Int) -> ListSectionProtocol? {
        return nil
    }
}
#endif
