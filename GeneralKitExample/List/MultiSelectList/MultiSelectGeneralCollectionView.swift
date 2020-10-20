//
//  MultiSelectGeneralCollectionView.swift
//  Jobs
//
//  Created by Salah on 11/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import UIKit
import Photos
import RxSwift
class MultiSelectGeneralCollectionView: GeneralCollectionView,MultiSelectGeneralViewProtocol,MultiSelectConnection{
    var selectedObjectCompletionHandler:Selection.Handlers.SelectedObjectCompletionHandler!
    var selectedObjectsCompletionHandler:Selection.Handlers.SelectedObjectsCompletionHandler!
    var deSelectedObjectCompletionHandler:Selection.Handlers.DeSelectedObjectCompletionHandler!
    var changeListenerCompletionHandler:Selection.Handlers.ChangeListenerCompletionHandler!
    var containsCompletionHandler:Selection.Handlers.ContainsCompletionHandler!
    
    var selectionType:Selection.SelectionType = .multiSelection
    var selectedObjects:[Any]=[Any]()
    
     func start() {
        self.selectedObjects.removeAll();
        super.start();
    }
    override func setupView() {
        super.setupView();
    }
    
    override func config(collectionView: UICollectionView, indexPath: IndexPath, object: GeneralCellData) -> UICollectionViewCell {
     var cell = super.config(collectionView: collectionView, indexPath: indexPath, object: object)  as! MultiSelectGeneralCellProtocol
        if self.selectionType == .multiSelection {
            self.multiCellForRowAt(cell: cell, self, cellForRowAt:indexPath);
        }else
            if self.selectionType == .single {
            self.singleCellForRowAt(cell: cell, self, cellForRowAt:indexPath);
        }
        return cell as! UICollectionViewCell;
    }
    override func itemSelected(_ event: Event<IndexPath>) {
        super.itemSelected(event);
        let cell = self.cellForItem(at: event.element!) as! MultiSelectGeneralCellProtocol
        if self.selectionType == .multiSelection {
            self.multiSelectiondidSelectRowAt(cell: cell, list: self, didSelectRowAt:  event.element!)
        }else
            if self.selectionType == .single {
            self.singleSelectionDidSelectRowAt(cell: cell, list: self, didSelectRowAt: event.element!)
        }
    }
    
}


