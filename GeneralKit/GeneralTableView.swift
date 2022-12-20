//
//  GeneralTableView.swift
//  GeneralKit
//
//  Created by SalahMohamed on 17/10/2022.
//

import UIKit

@objc public protocol GeneralTableViewCellProtocol{
    @objc optional func editing(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath,forObject object:GeneralCellData)
    @objc optional func editingStyleForRow(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
}
open class GeneralTableViewCell:UITableViewCell,GeneralListViewCellProtocol,GeneralTableViewCellProtocol {
    // MARK: - GeneralListViewProrocol
    public var list: GeneralListViewProrocol?
    public var listViewController: UIViewController?
    public var object: GeneralCellData?{
        if let indexPath:IndexPath=indexPath{
            return self.list?.objects.bs_get(indexPath.section)?.bs_get(indexPath.row)
        }
        return nil
    }
    public var indexPath: IndexPath?{
        return self.list?.indexPathForItemInList(at: self.center)
    }
    open func config(_ indexPath:IndexPath,
                     _ data: GeneralCellData){
    }
    open func itemSelected() {
    }
    
    // MARK: - GeneralTableViewCellProtocol
    open func editing(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath,forObject object:GeneralCellData) {
        
    }
    open func editingStyleForRow(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .none
    }
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        
    }
    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
    return nil
    }
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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
    public static var global:GeneralListConstant.Global=GeneralListConstant.global
    
    public var errorConnectionView: ListPlaceHolder?=global.errorConnectionDataViewHandler?()
    public var emptyDataView: ListPlaceHolder?=global.emptyDataViewHandler?()
    public var loadingDataView: ListPlaceHolder?=global.loadingDataHandler?()
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
    public var enableListPlaceHolderView:Bool=GeneralTableView.global.enableListPlaceHolderView{
        didSet{
            if self.enableListPlaceHolderView {

            }else{
                self.backgroundView?.removeFromSuperview();
                self.backgroundView=nil;
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
    func config(tableView:UITableView,indexPath:IndexPath,object:GeneralCellData)->UITableViewCell{
        let object:GeneralCellData = object
        var cell = self.dequeueReusableCell(withIdentifier:object.identifier, for: indexPath) as! GeneralListViewCellProtocol
        cell.list = self;
        cell.listViewController = self.listViewController
        cell.config(indexPath, self.objects[indexPath.section][indexPath.row])
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
    // MARK: - UITableViewDelegate
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.willDisplayCell?(indexPath)
        print(indexPath.row)
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects[section].count
    }
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.objects.count
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionViewHandler?(section)
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerSectionViewHandler?(section)
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return self.footerSectionHeightHandler?(section) ?? 0
    }
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return (self.listType == ListType.list) ? 0 : (self.sectionHeightHandler?(section) ?? 40)
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.config(tableView: self, indexPath: indexPath, object: self.objects[indexPath.section][indexPath.row]);
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSelected(indexPath);
    }
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCellProtocol
        return cell?.tableView?(tableView, canEditRowAt: indexPath) ?? false
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.objects.bs_get(indexPath.section)?.bs_get(indexPath.row)?.cellHeight ?? self.rowHeight
    }
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let cell:GeneralTableViewCellProtocol = tableView.cellForRow(at: indexPath) as? GeneralTableViewCellProtocol{
            return cell.editingStyleForRow?(tableView, editingStyleForRowAt: indexPath) ?? .none
        }
        return .none
    }
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCellProtocol
        cell?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath);
    }
    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCellProtocol
        return cell?.tableView?(tableView, trailingSwipeActionsConfigurationForRowAt:indexPath);
   }
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCellProtocol
        cell?.tableView?(tableView, commit: editingStyle, forRowAt:indexPath)
    }
    // MARK: - UI
    public func insertInList(indexPaths:[IndexPath]){
        self.performBatchUpdates({
        self.insertRows(at:indexPaths, with: .automatic)
        }, completion: { _ in
        })
    }
    public func reloadRowInList(indexPaths:[IndexPath]){
        self.performBatchUpdates({
            self.reloadRows(at:indexPaths, with: .automatic)
        }, completion: { _ in
        })
    }
    public func reloadSectionsInList(_ indexSet:IndexSet){
        self.performBatchUpdates({
        self.reloadSections(indexSet, with: .automatic)
        }, completion: { _ in
        })
    }
    public func deleteRowsInList(_ indexPath:[IndexPath]){
        self.performBatchUpdates({
            self.deleteRows(at:indexPath, with: UITableView.RowAnimation.automatic)
        }, completion: { _ in
        })
    }
    public func insertSectionsInList(sections:IndexSet){
        self.performBatchUpdates({
            self.insertSections(sections, with: .automatic)
        }, completion: { _ in
        })
    }
    public func indexPathForItemInList(at point: CGPoint) -> IndexPath? {
        return self.indexPathForRow(at: point)
    }
}
