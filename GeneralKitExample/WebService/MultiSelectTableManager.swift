////
////  MultiSelectTableView.swift
////  GraduationProject
////
////  Created by Salah on 10/7/18.
////  Copyright © 2018 Salah. All rights reserved.
////
//
import UIKit
import  RxCocoa
import RxSwift



protocol MultiSelectTableViewCellProtocol:TableViewCellProtocol{

    func selectedStyle();
    func deSelectedStyle();
}
class MultiSelectTableView:MultiCellTableManager {
    typealias ContainsCompletionHandler = (Any,Any)->Bool
    typealias SelectedObjectCompletionHandler = (Any)->Void
    typealias SelectedObjectsCompletionHandler = ([Any])->Void
    typealias DeSelectedObjectCompletionHandler = (Any)->Void
    typealias ChangeListenerCompletionHandler = ([Any])->Void
    var selectionType:SelectionType = .multiSelection
    
    var selectedObjectCompletionHandler:SelectedObjectCompletionHandler!
    var selectedObjectsCompletionHandler:SelectedObjectsCompletionHandler!
    var deSelectedObjectCompletionHandler:DeSelectedObjectCompletionHandler!
    var changeListenerCompletionHandler:ChangeListenerCompletionHandler!
    var containsCompletionHandler:ContainsCompletionHandler!

    public var selectedObjects:Variable<[Any]>=Variable<[Any]>([]);

        enum SelectionType {
            case single
            case multiSelection
        }
    override func setupView(){
        self.objects.asObservable().bind(to:self.tableView.rx.items) { tableView, row, group in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.dequeueReusableCell(withIdentifier:self.objects.value[row].identifier, for: indexPath) as! MultiSelectTableViewCellProtocol
            cell.config(self.tableView, row, self.objects.value[row], self);
            
                if self.selectionType == .multiSelection {
                    self.multiCellForRowAt(cell: cell, tableView, cellForRowAt: IndexPath.init(row: row, section: 0));
                }else{
                    self.singleCellForRowAt(cell: cell, tableView, cellForRowAt: IndexPath.init(row: row, section: 0));
                }
            return cell as! UITableViewCell
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.asControlEvent().subscribe { (event:Event<IndexPath>) in
            self.tableView.deselectRow(at: event.element!, animated: true);
            let cell = self.tableView.cellForRow(at: event.element!) as! MultiSelectTableViewCellProtocol
            cell.itemSelected(self.tableView,event.element!.row, self.objects.value[event.element!.row], self);
            if self.selectionType == .multiSelection {
            self.multiSelectiondidSelectRowAt(cell: cell, tableView: self.tableView, didSelectRowAt: event.element!);
            }else
            if self.selectionType == .single {
            self.singleSelectionDidSelectRowAt(cell: cell, tableView: self.tableView, didSelectRowAt: event.element!)
            }
            }.disposed(by: disposeBag);
    }
    


    func singleCellForRowAt(cell:MultiSelectTableViewCellProtocol,_ tableView: UITableView, cellForRowAt indexPath: IndexPath){
        if self.selectedObjects.value.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            cell.selectedStyle()
        }else{
            cell.deSelectedStyle()
        }
    }

    func multiCellForRowAt(cell:MultiSelectTableViewCellProtocol,_ tableView: UITableView, cellForRowAt indexPath: IndexPath){
        if self.selectedObjects.value.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            cell.selectedStyle()
        }else{
            cell.deSelectedStyle()
        }
    }
    func singleSelectionDidSelectRowAt(cell:MultiSelectTableViewCellProtocol,tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.selectedObjects.value.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            if self.deSelectedObjectCompletionHandler != nil {
                self.deSelectedObjectCompletionHandler!(self.objects.value[indexPath.row].object as! Any)
            }
            let index = self.selectedObjects.value.index { (object:Any) -> Bool in
                return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
            }
            self.selectedObjects.value.remove(at: index!)
        }else{
            self.selectedObjects.value.removeAll();
            self.selectedObjects.value.append(self.objects.value[indexPath.row].object as! AnyObject)
            cell.selectedStyle()
            if self.selectedObjectsCompletionHandler != nil {
                self.selectedObjectsCompletionHandler!(self.selectedObjects.value)
            }
            if self.selectedObjectCompletionHandler != nil {
                self.selectedObjectCompletionHandler(self.objects.value[indexPath.row].object as! AnyObject);
            }
        }
        if self.changeListenerCompletionHandler != nil {
            self.changeListenerCompletionHandler!(self.selectedObjects.value);
        }
    }
    func multiSelectiondidSelectRowAt(cell:MultiSelectTableViewCellProtocol,tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.selectedObjects.value.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
        }){
            if self.deSelectedObjectCompletionHandler != nil {
                self.deSelectedObjectCompletionHandler!(self.objects.value[indexPath.row].object as! Any)
            }
            let index = self.selectedObjects.value.index { (object:Any) -> Bool in
                return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any)
            }
            self.selectedObjects.value.remove(at: index!)
            cell.deSelectedStyle()
        }else{
            self.selectedObjects.value.append(self.objects.value[indexPath.row].object as! AnyObject)
            cell.selectedStyle()
            if self.selectedObjectsCompletionHandler != nil {
                self.selectedObjectsCompletionHandler!(self.selectedObjects.value)
            }
            if self.selectedObjectCompletionHandler != nil {
                self.selectedObjectCompletionHandler(self.objects.value[indexPath.row].object as! AnyObject);
            }
        }
        if self.changeListenerCompletionHandler != nil {
            self.changeListenerCompletionHandler!(self.selectedObjects.value);
        }
    }
    public func selectionType(_ selectionType: SelectionType){
        self.selectionType=selectionType;
    }
    public func contains(_ containsCompletionHandler:@escaping ContainsCompletionHandler){
        self.containsCompletionHandler=containsCompletionHandler;
    }
    public func selectedObjectCompletionHandler(_ selectedObjectCompletionHandler:@escaping SelectedObjectCompletionHandler){
        self.selectedObjectCompletionHandler=selectedObjectCompletionHandler;
    }
    public func selectedObjectsCompletionHandler(_ selectedObjectsCompletionHandler:@escaping SelectedObjectsCompletionHandler){
        self.selectedObjectsCompletionHandler=selectedObjectsCompletionHandler;
    }
    public func deSelectedObjectCompletionHandler(_ deSelectedObjectCompletionHandler:@escaping DeSelectedObjectCompletionHandler){
        self.deSelectedObjectCompletionHandler=deSelectedObjectCompletionHandler;
    }
    public func changeListenerCompletionHandler(_ changeListenerCompletionHandler:@escaping ChangeListenerCompletionHandler){
        self.changeListenerCompletionHandler=changeListenerCompletionHandler;
    }
    override func start() {
        self.selectedObjects.value.removeAll();
        super.start();
    }
}
