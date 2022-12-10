//
//  GeneralList.swift
//  GeneralKit
//
//  Created by SalahMohamed on 28/10/2022.
//

import Foundation
import Alamofire

public protocol ListPlaceHolder:UIView{
var list:GeneralListViewProrocol?{set get}
}

open class GeneralCellData: NSObject {
    public var identifier: String = ""
    public var object: Any?
    public var selected:Bool=false
    public var cellSize:CGSize?=nil
    public var cellHeight:CGFloat?=nil
    public init(identifier: String, object: Any?,cellSize:CGSize?=nil,cellHeight:CGFloat?=nil) {
        super.init()
        self.identifier = identifier
        self.object = object
        self.cellSize=cellSize;
        self.cellHeight=cellHeight;
    }
}
public struct GeneralListConstant {
    public static var global:Global=Global.init()
    public  struct Handlers {
        public typealias ListPlaceHolderHandler = () ->ListPlaceHolder;
        
        public typealias ConverterHandler = (Any) ->GeneralCellData;
        public typealias RefreshHnadler = () ->Void;
        public typealias RouterHandler = (BaseModel) ->[Any];
        public typealias SelectionHandler = (([Any])-> Void)
        public typealias ContainsHandler = (Any,Any)->Bool
        //tableview only
        public typealias SectionViewHandler = (Int)->UIView
        public typealias SectionViewHeightHandler = (Int)->CGFloat
        //collectionview only
        public typealias ViewForSupplementaryElementHandler = (String,IndexPath)->UICollectionReusableView
//        public typealias SectionViewHeightHandler = (Int)->CGFloat
    }
    public  struct Global{
        public var enableListPlaceHolderView:Bool=true;
        public var enableTableProgress: Bool=true;
        public var enableWaitingView: Bool=false
        public var enablePagination: Bool=true
        public var errorConnectionDataViewHandler:GeneralListConstant.Handlers.ListPlaceHolderHandler?
        public var emptyDataViewHandler:GeneralListConstant.Handlers.ListPlaceHolderHandler?
        public var loadingDataHandler:GeneralListConstant.Handlers.ListPlaceHolderHandler?

    }
   
}
public protocol GeneralListViewCellProtocol:class {
    var list:GeneralListViewProrocol!{ get set}
    var listViewController:UIViewController?{ get set}
    var indexPath:IndexPath?{get}
    var object:GeneralCellData?{get}

    func itemSelected();
    func config(_ indexPath:IndexPath,_ data:GeneralCellData)
}
public enum ObjectType{
case any(AnyHandling)
case data(DataHandling)
}
public enum AnyHandling{
case objects([[Any]])
case appendObject(section:Int=0,atRow:Int?,Any)
case appendNewSection(Int?,[Any])
case appendItemsInSection(section:Int=0,atRow:Int?,[Any])
case replaceObject(IndexPath,Any) // replce item in section

}
public enum DataHandling{
case objects([[GeneralCellData]])
case appendObject(section:Int=0,atRow:Int?,GeneralCellData)// work
case appendNewSection(Int?,[GeneralCellData]) // work
case appendItemsInSection(section:Int=0,atRow:Int?,[GeneralCellData])// work
case replaceObject(IndexPath,GeneralCellData) // replce item in section

}
public enum ItemType{
case new([Any]) // new
case append([Any]) //append
case appendObject(section:Int=0,Any) //append
case newSections([[GeneralCellData]]) // new
case appendSection([GeneralCellData]) // new
case replaceObject(Any,IndexPath) // replce item in section
}
public enum ListType{
    case list
    case section
}
public enum SelectionType{
    case single(optional:Bool=false)
    case multi
    case non
    case signleSection
}
public protocol GeneralListViewProrocol:class {
    var refreshHandler:GeneralListConstant.Handlers.RefreshHnadler?{get set}
    var routerHandler:GeneralListConstant.Handlers.RouterHandler?{get set}
    var converterHandler:GeneralListConstant.Handlers.ConverterHandler?{get set}
    var responseHandler:RequestOperationBuilder<BaseModel>.FinishHandler?{get set}
    
    var containsHandler:GeneralListConstant.Handlers.ContainsHandler?{get set}
    var selectionHandler:GeneralListConstant.Handlers.SelectionHandler?{get set}
    
    static var global:GeneralListConstant.Global{get set}
    var objects:[[GeneralCellData]]{ get set}
    var listViewController:UIViewController?{ get set}
    var paginator:PaginationManagerProtocol?{get set}
    var identifier: String?{get set}
    var refreshControl:UIRefreshControl?{get set}
    var enableListPlaceHolderView:Bool{get set}
    var enableTableProgress:Bool{get set}
    var enablePagination:Bool{get set}
    var enablePullToRefresh:Bool{get set}
    var backgroundView: UIView?{get set}
    var errorConnectionView: ListPlaceHolder?{get set}//=ListPlaceHolderView.defaultErrorConnectionData;
    var emptyDataView: ListPlaceHolder?{get set}//=ListPlaceHolderView.defaultEmptyData;
    var loadingDataView: ListPlaceHolder?{get set}//=ListPlaceHolderView.defaultLoadingData;
    func paginationManager(_ paginationManager:PaginationManagerProtocol) -> Self
    func start();
    func reloadData()
    var  selectionType:SelectionType{ get set}
    func selectAndDeselect(_ object:GeneralCellData)
    func handleRemove(_ indexPaths:[IndexPath])
    //UI
    func insertInList(indexPaths:[IndexPath]);
    func reloadRowInList(indexPaths:[IndexPath]);
    func reloadSectionsInList(_ indexSet:IndexSet)
    func deleteRowsInList(_ indexPath:[IndexPath]);
    func insertSectionsInList(sections:IndexSet)
}

public protocol GeneralConnection:GeneralListViewProrocol{
    
}
// webservice and object handling
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
    @discardableResult public  func refreshHandler (_ refreshHandler:@escaping GeneralListConstant.Handlers.RefreshHnadler) -> Self{
        self.refreshHandler=refreshHandler;
        return self;
    }
    @discardableResult public func responseHandler (_ refreshHandler:@escaping RequestOperationBuilder<BaseModel>.FinishHandler) -> Self{
        self.responseHandler=responseHandler;
        return self;
    }
    @discardableResult public func identifier(_ identifier:String) -> Self{
        self.identifier=identifier;
        return self;
    }
    func converterObject(_ object:Any?)->GeneralCellData{
        let generalCellData = self.converterHandler?(object) ?? GeneralCellData.init(identifier:self.identifier ?? "", object:object);
        generalCellData.selected = self.selectedObject.contains(where: { item in self.containsCheck(item,object)})
        return generalCellData
    }
    func convertObjects(_ objects:[Any])->[GeneralCellData]{
    return objects.map({converterObject($0)})
    }
    public func refreshStyle(_ error:Error?){
        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
        if self.handlePlaceHolderViewConnectionError(error,enableListPlaceHolderView:self.enableListPlaceHolderView) == false {
            self.handlePlaceHolderViewEmptyData(objects: objects, enableListPlaceHolderView: self.enableListPlaceHolderView)
        }
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
    public func handleRemove(_ indexPaths:[IndexPath]){
        for indexPath in indexPaths{
            self.objects[indexPath.section].remove(at: indexPath.row);
        }
        self.deleteRowsInList(indexPaths)
    }
    public func handle(_ objectType:ObjectType,_ error:Error?=nil,_ autoHandle:Bool=true){
        switch objectType{
        case .any(let anyHandling):
            switch anyHandling {
            case .objects(let items):
                var cells:[[GeneralCellData]] = [[GeneralCellData]]()
                for  sectionArray in items{
                cells.append(self.convertObjects(sectionArray))
                }
                self.objects=cells;
                if autoHandle{ self.reloadData()}
                break;
            case .appendObject(section: let section,atRow:let row, let item):
                self.appendObject(section, row,self.converterObject(item), autoHandle: true)
                break;
            case .appendNewSection(let index,let items):
                self.appendNewSection(index,self.convertObjects(items), true);
                break;
            case .appendItemsInSection(section: let section,let row, let items):
                self.appendItemsInSection(section, row,self.convertObjects(items), autoHandle);
                break;
            case .replaceObject(let indexPath, let item):
                self.replaceObject(indexPath, self.converterObject(item), autoHandle)
                break;
            }
            break;
        case .data(let dataHandling):
            switch dataHandling{
            case .objects(let items):
                self.objects = items
                if autoHandle{
                self.reloadData();
                }
                break;
            case .appendObject(section: let section,atRow:let row,let item):
                appendObject(section, row, item, autoHandle: autoHandle)
                break;
            case .appendNewSection(let index,let items):
                self.appendNewSection(index,items,autoHandle)
                break
            case .appendItemsInSection(section: let section,let row, let items):
                appendItemsInSection(section,row,items,autoHandle);
                break
            case .replaceObject(let indexPath, let item):
                self.replaceObject(indexPath, item, autoHandle)
                break
            }
            self.refreshStyle(error)
            break;
        }
    }
    // UI
    func appendObject(_ section:Int,_ row:Int?,_ item:GeneralCellData,autoHandle:Bool){
        if let row:Int=row{
            self.objects[section].insert(item, at: row)
        }else{
            self.objects[section].append(item)
        }
        if autoHandle{
        self.insertInList(indexPaths:[IndexPath.init(row: row ?? (self.objects[section].count-1),section:section)])
        }
    }
    func appendNewSection(_ index:Int?,_ items:[GeneralCellData],_ autoHandle:Bool){
        let index = index ?? self.objects.count
        self.objects.insert(items, at: index)
        if autoHandle{
        let section = index
        self.insertSectionsInList(sections: IndexSet([section]))
        }
    }
    func appendItemsInSection(_ section:Int,_ row:Int?,_ items:[GeneralCellData],_ autoHandle:Bool){
        let cutomeRow = row ?? self.objects[section].count
        self.objects[section].insert(contentsOf: items, at: cutomeRow)
        if autoHandle{
        self.insertInList(indexPaths: items.indexPaths(section:section,cutomeRow))
        }
    }
    func replaceObject(_ indexPath:IndexPath,_ item:GeneralCellData,_ autoHandle:Bool){
        var tempItems = self.objects.bs_get(indexPath.section) ?? []
        tempItems.remove(at:indexPath.row)
        tempItems.insert(contentsOf: [item], at: indexPath.row);
        if autoHandle{
        self.reloadRowInList(indexPaths: [indexPath])
        }
    }
    //
    func viewsSetup(){
        self.errorConnectionView = Self.global.errorConnectionDataViewHandler?()
        self.errorConnectionView?.list = self
        self.emptyDataView =  Self.global.emptyDataViewHandler?()
        self.emptyDataView?.list = self
        self.loadingDataView =  Self.global.loadingDataHandler?()
        self.loadingDataView?.list = self
    }
    func handlePlaceHolderViewEmptyData(objects:[[GeneralCellData]]?,enableListPlaceHolderView:Bool){
        if enableListPlaceHolderView {
            if objects?.count ?? 0 == 0 || ((objects?.count ?? 0) == 1 && objects?.bs_get(0)?.count ?? 0 == 0) {
            self.backgroundView=self.emptyDataView;
        }else{
            self.backgroundView?.removeFromSuperview();
            self.backgroundView = nil
        }
        }else{
            self.backgroundView?.removeFromSuperview();
            self.backgroundView = nil
        }
    }
    func handlePlaceHolderViewConnectionError(_ afError:Error?,enableListPlaceHolderView:Bool)->Bool{
        if enableListPlaceHolderView {
        if let err = afError as? URLError,(err.code == URLError.Code.notConnectedToInternet) ||
            (err.code == URLError.Code.networkConnectionLost) ||
            (err.code == URLError.Code.dataNotAllowed){
            self.backgroundView=self.errorConnectionView;
            return true
        }else
            if let err = afError as? AFError{
            switch err {
            case .sessionTaskFailed(error: let error):
                if let err = error as? URLError,(err.code == URLError.Code.notConnectedToInternet) ||
                    (err.code == URLError.Code.networkConnectionLost) ||
                    (err.code == URLError.Code.dataNotAllowed){
                    self.backgroundView=self.errorConnectionView;
                    return true
                }
            default:
                break;
            }
            return false
        }
    else{
            self.backgroundView?.removeFromSuperview();
            self.backgroundView = nil
            return false
        }
        }else{
            self.backgroundView?.removeFromSuperview();
            self.backgroundView = nil
            return false
        }
    }
    func handlePlaceHolderViewLoading(start:Bool,enableListPlaceHolderView:Bool){
        if enableListPlaceHolderView {
            if start {
            self.backgroundView = loadingDataView;
            }else{
                self.backgroundView?.removeFromSuperview();
                self.backgroundView = nil
            }
        }else{
            self.backgroundView?.removeFromSuperview();
            self.backgroundView = nil
        }
    }
    func refreshHandler(_ refreshHandler:@escaping GeneralListConstant.Handlers.RefreshHnadler)
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
// selection
extension GeneralListViewProrocol where Self:GeneralConnection{
     private var allObjects:Array<GeneralCellData>{
  return self.objects.flatMap { (items:Array<GeneralCellData>) -> [GeneralCellData] in
      return items}
    }
    func containsCheck(_ object1:Any,_ object2:Any)->Bool{
        return self.containsHandler?(object1,object2) ?? false
    }
    public var selectedObject:[Any]{
        set{
            for object in newValue{
                var cellsData = self.allObjects.filter { (internalObject) -> Bool in
                    return self.containsCheck(object,internalObject.object)}
                for object in cellsData{
                    object.selected=true;
                }
            }
            self.reloadData();
        }
        get{
            var tempSelected = [Any]();
            for item in self.objects{
                var items = item.filter { (data) -> Bool in
                    return data.selected;};
                var mappedItems = items.map({ (data) -> Any in
                                                return data.object ?? ""})
                tempSelected.append(contentsOf:mappedItems);
            }
            return tempSelected;
        }
    }
    public func selectAndDeselect(_ object:GeneralCellData){
        switch self.selectionType {
        case .multi:
            object.selected = !(object.selected);
//            self.reloadData();
            self.selectionHandler?(self.selectedObject);
            break;
        case .single(let optional):
            for tempObject in self.allObjects{
                if self.containsCheck(tempObject.object, object.object) == false{
                    tempObject.selected=false
                }
            }
            if optional == false{
                object.selected=true;
            }else{
                object.selected = !object.selected;
            }
//            self.reloadData();
            self.selectionHandler?(self.selectedObject);
            break;
        case .non:
            break;
        case .signleSection:
            break
        }
    }
}
