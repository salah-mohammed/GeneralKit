//
//  MultiSelectGeneralList.swift
//  Jobs
//
//  Created by Salah on 1/21/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
import RxSwift

struct Selection {
    enum SelectionType {
        case single
        case multiSelection
        case none
        
    }
    public  struct Handlers {
        typealias ContainsCompletionHandler = (Any,Any)->Bool
        typealias SelectedObjectCompletionHandler = (Any)->Void
        typealias SelectedObjectsCompletionHandler = ([Any])->Void
        typealias DeSelectedObjectCompletionHandler = (Any)->Void
        typealias ChangeListenerCompletionHandler = ([Any])->Void
    }
}
// for tableViewCell && collectionviewCell
protocol MultiSelectGeneralCellProtocol:GeneralListViewCellProtocol{
    func selectedStyle();
    func deSelectedStyle();
}
// for tableView && collectionview
protocol MultiSelectGeneralViewProtocol:GeneralListViewProrocol {
    var selectedObjects:[Any]{ get set}
    var selectionType:Selection.SelectionType { set get}
    
    var selectedObjectCompletionHandler:Selection.Handlers.SelectedObjectCompletionHandler!{ get set}
    var selectedObjectsCompletionHandler:Selection.Handlers.SelectedObjectsCompletionHandler!{ get set}
    var deSelectedObjectCompletionHandler:Selection.Handlers.DeSelectedObjectCompletionHandler!{ get set}
    var changeListenerCompletionHandler:Selection.Handlers.ChangeListenerCompletionHandler!{ get set}
    var containsCompletionHandler:Selection.Handlers.ContainsCompletionHandler!{ get set}
}

protocol MultiSelectConnection:MultiSelectGeneralViewProtocol{
    
}
class GeneralMultiSelectTableViewCell:GeneralTableViewCell,MultiSelectGeneralCellProtocol {
    func selectedStyle() {
        
    }
    
    func deSelectedStyle() {
        
    }
}
extension MultiSelectGeneralViewProtocol where Self: MultiSelectConnection {
    @discardableResult  func selectionType(_ selectionType: Selection.SelectionType)->Self{
        self.selectionType=selectionType;
        return self
    }
    @discardableResult  func contains(_ containsCompletionHandler:@escaping Selection.Handlers.ContainsCompletionHandler)->Self{
        self.containsCompletionHandler=containsCompletionHandler;
        return self;
    }
    @discardableResult   func selectedObjectCompletionHandler(_ selectedObjectCompletionHandler:@escaping Selection.Handlers.SelectedObjectCompletionHandler)->Self{
        self.selectedObjectCompletionHandler=selectedObjectCompletionHandler;
        return self
    }
    @discardableResult   func selectedObjectsCompletionHandler(_ selectedObjectsCompletionHandler:@escaping Selection.Handlers.SelectedObjectsCompletionHandler)->Self{
        self.selectedObjectsCompletionHandler=selectedObjectsCompletionHandler;
        return self
    }
    @discardableResult   func deSelectedObjectCompletionHandler(_ deSelectedObjectCompletionHandler:@escaping Selection.Handlers.DeSelectedObjectCompletionHandler)->Self{
        self.deSelectedObjectCompletionHandler=deSelectedObjectCompletionHandler;
        return self
    }
    @discardableResult   func changeListenerCompletionHandler(_ changeListenerCompletionHandler:@escaping Selection.Handlers.ChangeListenerCompletionHandler)->Self{
        self.changeListenerCompletionHandler=changeListenerCompletionHandler;
        return self
    }
    func multiSelectiondidSelectRowAt(cell:MultiSelectGeneralCellProtocol, list: MultiSelectGeneralViewProtocol, didSelectRowAt indexPath: IndexPath){
        if self.selectedObjects.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            if self.deSelectedObjectCompletionHandler != nil {
                self.deSelectedObjectCompletionHandler!(self.objects.value[indexPath.row].object as! Any)
            }
            let index = self.selectedObjects.index { (object:Any) -> Bool in
                return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
            }
            self.selectedObjects.remove(at: index!)
            cell.deSelectedStyle()
        }else{
            self.selectedObjects.append(self.objects.value[indexPath.row].object as! AnyObject)
            cell.selectedStyle()
            if self.selectedObjectsCompletionHandler != nil {
                self.selectedObjectsCompletionHandler!(self.selectedObjects)
            }
            if self.selectedObjectCompletionHandler != nil {
                list.selectedObjectCompletionHandler(self.objects.value[indexPath.row].object as! AnyObject);
            }
        }
        if self.changeListenerCompletionHandler != nil {
            self.changeListenerCompletionHandler!(self.selectedObjects);
        }
    }
    func singleSelectionDidSelectRowAt(cell:MultiSelectGeneralCellProtocol,list: MultiSelectGeneralViewProtocol, didSelectRowAt indexPath: IndexPath){
        if self.selectedObjects.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            if self.deSelectedObjectCompletionHandler != nil {
                self.deSelectedObjectCompletionHandler!(self.objects.value[indexPath.row].object as! Any)
            }
            let index = self.selectedObjects.index { (object:Any) -> Bool in
                return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
            }
            self.selectedObjects.remove(at: index!)
        }else{
            self.selectedObjects.removeAll();
            self.selectedObjects.append(self.objects.value[indexPath.row].object as! AnyObject)
            if self.selectedObjectsCompletionHandler != nil {
                self.selectedObjectsCompletionHandler!(self.selectedObjects)
            }
            if self.selectedObjectCompletionHandler != nil {
                self.selectedObjectCompletionHandler(self.objects.value[indexPath.row].object as! AnyObject);
            }
        }
        self.reloadData();
        if self.changeListenerCompletionHandler != nil {
            self.changeListenerCompletionHandler!(self.selectedObjects);
        }
    }
    func singleCellForRowAt(cell:MultiSelectGeneralCellProtocol,_ list: MultiSelectGeneralViewProtocol, cellForRowAt indexPath: IndexPath){
        if self.selectedObjects.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            cell.selectedStyle()
        }else{
            cell.deSelectedStyle()
        }
    }
    
    func multiCellForRowAt(cell:MultiSelectGeneralCellProtocol,_ list: MultiSelectGeneralViewProtocol, cellForRowAt indexPath: IndexPath){
        if self.selectedObjects.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            cell.selectedStyle()
        }else{
            cell.deSelectedStyle()
        }
    }
    
}


