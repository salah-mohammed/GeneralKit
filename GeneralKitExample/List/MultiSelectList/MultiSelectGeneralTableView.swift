//
//  MultiSelectGeneralTableView.swift
//  Jobs
//
//  Created by Salah on 11/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import UIKit
import RxSwift

class MultiSelectGeneralTableView: GeneralTableView,MultiSelectGeneralViewProtocol,MultiSelectConnection{
    var selectedObjectCompletionHandler:Selection.Handlers.SelectedObjectCompletionHandler!
    var selectedObjectsCompletionHandler:Selection.Handlers.SelectedObjectsCompletionHandler!
    var deSelectedObjectCompletionHandler:Selection.Handlers.DeSelectedObjectCompletionHandler!
    var changeListenerCompletionHandler:Selection.Handlers.ChangeListenerCompletionHandler!
    var containsCompletionHandler:Selection.Handlers.ContainsCompletionHandler!
    
    var selectionType:Selection.SelectionType = .none
    var selectedObjects:[Any]=[Any]()

     public func start() {
        super.start();
    }
    override func setupView(){
        super.setupView();
        DebugError.debug(debug: self.containsCompletionHandler);
        let tempEnableListPlaceHolderView=self.enableListPlaceHolderView;
        self.enableListPlaceHolderView=tempEnableListPlaceHolderView;
    }

    override func config(tableView:UITableView,indexPath:IndexPath,object:GeneralCellData)->UITableViewCell{
       let cell = super.config(tableView: tableView, indexPath: indexPath, object: object) as! MultiSelectGeneralCellProtocol
        if self.selectionType == .multiSelection {
            self.multiCellForRowAt(cell: cell, self, cellForRowAt:indexPath);
        }else
            if self.selectionType == .single {
            self.singleCellForRowAt(cell: cell, self, cellForRowAt:indexPath);
        }
        return cell as! UITableViewCell
    }
    override func itemSelected(_ event:Event<IndexPath>){
        super.itemSelected(event)
        self.deselectRow(at: event.element!, animated: true);
        let cell = self.cellForRow(at: event.element!) as! MultiSelectGeneralCellProtocol
        if self.selectionType == .multiSelection {
            self.multiSelectiondidSelectRowAt(cell: cell, list: self, didSelectRowAt:  event.element!)
        }else
            if self.selectionType == .single {
            self.singleSelectionDidSelectRowAt(cell: cell, list: self, didSelectRowAt: event.element!)
        }
    }
}
