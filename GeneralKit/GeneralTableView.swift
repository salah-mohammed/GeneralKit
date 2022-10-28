//
//  GeneralTableView.swift
//  GeneralKit
//
//  Created by SalahMohamed on 17/10/2022.
//

import UIKit

open class GeneralTableViewCell:UITableViewCell,GeneralListViewCellProtocol {
    public var list: GeneralListViewProrocol!
    public var listViewController: UIViewController?
    public var indexPath: IndexPath!
    public var object: GeneralCellData!{return self.list.objects[indexPath.section][indexPath.row]};

    final public func config(_ list:GeneralListViewProrocol,_ listViewController:UIViewController?,_ indexPath:IndexPath){
        self.list = list as! GeneralTableView
        self.listViewController=listViewController;
        self.indexPath=indexPath;
        self.config();
    }
    open func config(){
    }
    open func itemSelected() {
    }
    func editing(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath,forObject object:GeneralCellData) {
        
    }
    func editingStyleForRow(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .none
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

open class GeneralTableView: UITableView,GeneralListViewProrocol,GeneralConnection,UITableViewDelegate,UITableViewDataSource {
    // tableView only
    public var sectionViewHandler:GeneralListConstant.Handlers.SectionViewHandler?
    public var sectionHeightHandler:GeneralListConstant.Handlers.SectionViewHeightHandler?
    public var footerSectionViewHandler:GeneralListConstant.Handlers.SectionViewHandler?
    public var footerSectionHeightHandler:GeneralListConstant.Handlers.SectionViewHeightHandler?
    public var listType:ListType = .list
    ////
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
                self.addInfiniteScroll { (tableView:UITableView) in
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
    public var selectionHandler :GeneralListConstant.Handlers.SelectionHandler?
    public var containsHandler:GeneralListConstant.Handlers.ContainsHandler?
    ////////////////////////-
    var willDisplayCell : (((IndexPath)-> Void))?
    func willDisplayCell (_ willDisplayCell: (((IndexPath)-> Void))?) -> Self{
        self.willDisplayCell = willDisplayCell;
        return self
    }
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
    ///
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.willDisplayCell?(indexPath)
        print(indexPath.row)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects[section].count
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.objects.count
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionViewHandler?(section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerSectionViewHandler?(section)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return self.footerSectionHeightHandler?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return (self.listType == ListType.list) ? 0 : (self.sectionHeightHandler?(section) ?? 40)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.config(tableView: self, indexPath: indexPath, object: self.objects[indexPath.section][indexPath.row]);
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSelected(indexPath);
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCell
        return cell?.tableView(tableView, canEditRowAt: indexPath) ?? false
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.objects.bs_get(indexPath.section)?.bs_get(indexPath.row)?.cellHeight ?? self.rowHeight
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let cell:GeneralTableViewCell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCell{
            return cell.editingStyleForRow(tableView, editingStyleForRowAt: indexPath)
        }
        return .none
    }
}
