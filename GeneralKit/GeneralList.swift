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
public protocol ListSectionProtocol{
    var section:Int?{set get}
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
public protocol GeneralListViewCellProtocol{
    var list:GeneralListViewProrocol?{ get set}
    var listViewController:UIViewController?{ get set}
    var indexPath:IndexPath?{get}
//    var object:GeneralCellData?{get}


    func itemSelected(_ indexPath:IndexPath,
                      _ data: GeneralCellData?);
    func config(_ indexPath:IndexPath,_ data:GeneralCellData?)
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
    var errorConnectionView: ListPlaceHolder?{get set}
    var emptyDataView: ListPlaceHolder?{get set}
    var loadingDataView: ListPlaceHolder?{get set}
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
    func indexPathForItemInList(at point: CGPoint)->IndexPath?
    func listHeaderView(forSection:Int)->ListSectionProtocol?
    
}

public protocol GeneralConnection:GeneralListViewProrocol,GeneralRealmListViewProrocol{
    
}
// webservice and object handling
extension GeneralListViewProrocol /*where Self: GeneralConnection*/ {
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
    @discardableResult public func identifier(_ identifier:String) -> Self{
        self.identifier=identifier;
        return self;
    }
    func converterObject(_ object:Any?)->GeneralCellData{
        let generalCellData = self.converterHandler?(object) ?? GeneralCellData.init(identifier:self.identifier ?? "", object:object);
        generalCellData.selected = self.selectedObject.contains(where:{ [weak self] item in self?.containsCheck(item,object) ?? false})
        return generalCellData
    }
    func convertObjects(_ objects:[Any])->[GeneralCellData]{
        return objects.map({ [weak self] a in self!.converterObject(a)})
    }
    public func refreshStyle(_ error:Error?){
        self.handlePlaceHolderViewLoading(start:false,enableListPlaceHolderView:self.enableListPlaceHolderView);
        if self.handlePlaceHolderViewConnectionError(error,enableListPlaceHolderView:self.enableListPlaceHolderView) == false {
            self.handlePlaceHolderViewEmptyData(objects:objects, enableListPlaceHolderView: self.enableListPlaceHolderView)
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
        var objects = self.objects ?? []
        for indexPath in indexPaths{
            objects[indexPath.section].remove(at: indexPath.row);
        }
        self.deleteRowsInList(indexPaths)
    }
    public func handleAny(_ anyHandling:AnyHandling,_ error:Error?=nil,_ autoHandle:Bool=true){
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
        self.refreshStyle(error)
    }
    public func handleData(_ dataHandling:DataHandling,_ error:Error?=nil,_ autoHandle:Bool=true){
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
      }
    private func handle(_ objectType:ObjectType,_ error:Error?=nil,_ autoHandle:Bool=true){
        switch objectType{
        case .any(let anyHandling):
            self.handleAny(anyHandling,error,autoHandle)
            break;
        case .data(let dataHandling):
            self.handleData(dataHandling,error,autoHandle)
            break;
        }
    }
    // UI
    private func appendObject(_ section:Int,_ row:Int?,_ item:GeneralCellData,autoHandle:Bool){
        if let row:Int=row{
            objects[section].insert(item, at: row)
        }else{
            objects[section].append(item)
        }
        if autoHandle{
        self.insertInList(indexPaths:[IndexPath.init(row: row ?? (objects[section].count-1),section:section)])
        }
    }
    private func appendNewSection(_ index:Int?,_ items:[GeneralCellData],_ autoHandle:Bool){
        let section = index ?? objects.count
        objects.insert(items, at: section)
        if autoHandle{
        self.insertSectionsInList(sections: IndexSet([section]))
        }
        if let index:Int = index{
            let lastSections = index ... (objects.count-1)
            for tempSection in lastSections{
                var sectionView = self.listHeaderView(forSection:tempSection)
                sectionView?.section = tempSection
                print(tempSection)
            }

        }
    }
    private func appendItemsInSection(_ section:Int,_ row:Int?,_ items:[GeneralCellData],_ autoHandle:Bool){
        if let cutomeRow:Int = row ?? objects.bs_get(section)?.count{
            objects[section].insert(contentsOf: items, at: cutomeRow)
            if autoHandle{
            self.insertInList(indexPaths: items.indexPaths(section:section,cutomeRow))
            }
        }else{
            self.appendNewSection(nil, items,autoHandle)
        }
    }
    private func replaceObject(_ indexPath:IndexPath,_ item:GeneralCellData,_ autoHandle:Bool){
        var tempItems = objects.bs_get(indexPath.section) ?? []
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
        self.objects.removeAll()
        self.handlePlaceHolderViewLoading(start:true,enableListPlaceHolderView:self.enableListPlaceHolderView);
        if self.enableTableProgress{
            self.refreshControl?.beginRefreshing()
        }
        self.paginator?.start();
    }
}
// selection
extension GeneralListViewProrocol /*where Self:GeneralConnection*/{
     private var allObjects:Array<GeneralCellData>{
  return self.objects.flatMap {[weak self] (items:Array<GeneralCellData>) -> [GeneralCellData] in
      return items}
    }
    func containsCheck(_ object1:Any,_ object2:Any)->Bool{
        return self.containsHandler?(object1,object2) ?? false
    }
    public var selectedObject:[Any]{
        set{
            for object in newValue{
                var cellsData = self.allObjects.filter {[weak self] (internalObject) -> Bool in
                    return self?.containsCheck(object,internalObject.object) ?? false}
                for object in cellsData{
                    object.selected=true;
                }
            }
            self.reloadData();
        }
        get{
            var tempSelected = [Any]();
            for item in self.objects{
                var items = item.filter {[weak self] (data) -> Bool in
                    return data.selected;};
                var mappedItems = items.map({[weak self] (data) -> Any in
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
                self.handleAny(.objects([[objects]]), nil,false)
                self.reloadData()
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
                        self.handleAny(.appendItemsInSection(atRow: nil, objects),nil,false)
                        self.reloadData()
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
