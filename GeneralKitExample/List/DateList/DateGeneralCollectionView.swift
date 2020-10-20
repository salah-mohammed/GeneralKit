//
//  DateGeneralCollectionView.swift
//  Jobs
//
//  Created by Salah on 3/15/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class DateGeneralCollectionView: MultiSelectGeneralCollectionView,DateGeneralViewProtocol,DateConnection{
    var currentDate:Date = Date.init();
    var startDate:Date?;
    var endDate:Date?;
    
    override func setupView() {
        super.setupView();
        self.isPagingEnabled=true;
    }
    override func itemSelected(_ event: Event<IndexPath>) {
        super.itemSelected(event);
    }
    override func config(collectionView: UICollectionView, indexPath: IndexPath, object: GeneralCellData) -> UICollectionViewCell {
        let cell = super.config(collectionView: collectionView, indexPath: indexPath, object: object) as! DateGeneralCellProtocol
        
        if self.containsCompletionHandler(self.currentDate,cell.object.object) && !(self.selectedObjects.contains(where: { (object:Any) -> Bool in
            return self.containsCompletionHandler(object,self.objects.value[indexPath.row].object as Any) })){
            cell.currentDateStyle();
        }
        
        return cell as! UICollectionViewCell;
    }
}
