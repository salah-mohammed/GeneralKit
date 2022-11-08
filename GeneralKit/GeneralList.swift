//
//  GeneralList.swift
//  GeneralKit
//
//  Created by SalahMohamed on 28/10/2022.
//

import Foundation
import Alamofire
import Realm
import RealmSwift
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
    public enum OperationsHandler {
        case initial([Any])
        case deletions([Any])
        case insertions([Any])
        case modifications([Any])
    }
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
        public typealias SortHandler = (Any,Any) ->Bool;

    }
    public  struct Global{
        public var enableListPlaceHolderView:Bool=true;
        public var enableTableProgress: Bool=true;
        public var enableWaitingView: Bool=false
        public var enablePagination: Bool=true
        public var errorConnectionDataViewHandler:GeneralListConstant.Handlers.ListPlaceHolderHandler?
        public var emptyDataViewHandler:GeneralListConstant.Handlers.ListPlaceHolderHandler?
        public var loadingDataHandler:GeneralListConstant.Handlers.ListPlaceHolderHandler?
        public var sortHandler:GeneralListConstant.Handlers.SortHandler?

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
    var sortHandler:GeneralListConstant.Handlers.SortHandler?{get set}

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
    func handle(itemsType:ItemType,_ error:Error?)
}

public protocol GeneralConnection:GeneralListViewProrocol,GeneralRealmListViewProrocol{
    
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
    public func handle(itemsType:ItemType,_ error:Error?){
        switch itemsType{
        case.appendObject(let section,let item):
            self.objects[section].append(converterObject({item}))
            break
        case .append(let items):
            var tempItems = self.objects.bs_get(0) ?? []
            tempItems.append(contentsOf:items.map({converterObject($0)}))
            self.objects = [tempItems]
            break;
        case .new(let items):
            self.objects=[items.map({converterObject($0)})]
            break;
        case .newSections(let objects):
            self.objects=objects
            break;
        case .replaceObject(let object,let indexPath):
            let tempItems = self.objects.bs_get(indexPath.section) ?? []
            tempItems.bs_get(indexPath.row)?.object = object
            break;
        case .appendSection(let objects):
            self.objects.append(objects)
        }
        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
        if self.handlePlaceHolderViewConnectionError(error,enableListPlaceHolderView:self.enableListPlaceHolderView) == false {
            self.handlePlaceHolderViewEmptyData(objects: objects, enableListPlaceHolderView: self.enableListPlaceHolderView)
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





public protocol GeneralRealmListViewProrocol:GeneralListViewProrocol {
    var relam:Realm?{get set}
    var notificationToken:NotificationToken?{get set}
}
extension GeneralRealmListViewProrocol {

    public  func realm<T: Object>(_ ofType:T.Type)->Results<T> {
        return  self.relam!.objects(ofType.self)
    }
    public func handleRelam<T: Object>(objects:Results<T>)->[Any]{
        var array:[Any]=[Any]();
        for index in 0 ..< objects.count {
            if let result = objects[index] as? T {
            array.append(result);
            }
        }
        return array;
    }
   public func executeRealm<T: Object>(ofType:T.Type,filter:((Results<T>)->Results<T>)?,operationHandler:((GeneralListConstant.OperationsHandler)->Void)?,observeChange:(([GeneralCellData])->Void)?){
        let objects = self.realm(ofType);
        let results:Results<T> = filter?(objects) ?? objects;

         self.notificationToken = results.observe { change in
            switch change {
            case .initial(let results):
                let objects = self.handleRelam(objects:results);
                self.handle(itemsType:ItemType.append(objects), nil)
                operationHandler?(.initial(self.objects[0]));
                observeChange?(self.objects[0]);
                break
            case .update(let collection, let deletions, let insertions,let modifications):
                DispatchQueue.main.async {
                    if modifications.count > 0 {
                        self.modifications(rows:modifications);
                        operationHandler?(.modifications(modifications.map({ (index) -> GeneralCellData in
                            return self.objects[0][index]
                        })));
                        observeChange?(self.objects[0]);
                    }else
                    if deletions.count > 0 {
//                      let objects = self.deletions(deletions: deletions, objects:self.objects.value);
//                        self.objects.value = objects;
                 //       operationHandler?(.deletions(objects));
                        observeChange?(self.objects[0]);

                    }else
                    if insertions.count > 0 {
                       let objects = self.insertions(insertions: insertions,collection: collection)
                        self.handle(itemsType:ItemType.append(objects), nil)
                        operationHandler?(.insertions(objects));
                        observeChange?(self.objects[0]);
                    }
                }
                break;

            default: ()
            }
        }
    }
    func modifications(rows:[Int]){
//        var objects = self.objects.value
//        self.objects.value = objects;
        self.reloadData();
    }
    func insertions<T:Object>(insertions:[Int],collection:Results<T>)->[Any]{
        let objects :[Any] = insertions.map { (index) -> T in return collection[index] }.sorted(by: { (object1:T, object2:T) -> Bool in
            return self.sortHandler?(object1,object2) ?? true
            })
        return objects
    }
    func deletions(deletions:[Int], objects:[GeneralCellData])->[GeneralCellData]{
        var mainObjects = objects;
        for index in deletions {
            mainObjects.remove(at: index);
        }
       return mainObjects;

    }
}
