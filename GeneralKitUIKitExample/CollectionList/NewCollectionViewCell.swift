//
//  NewCollectionViewCell.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class NewCollectionViewCell:GeneralCollectionViewCell {
    override func config(_ indexPath: IndexPath,
                         _ data:GeneralCellData) {
        super.config(indexPath, data)
        self.backgroundColor = self.object?.selected ?? false ? UIColor.red:UIColor.yellow;
    }
    override func itemSelected() {
        super.itemSelected();
        if let  object:GeneralCellData = self.object{
            self.list?.selectAndDeselect(object);
        }
        self.list?.reloadData();
    }
}
