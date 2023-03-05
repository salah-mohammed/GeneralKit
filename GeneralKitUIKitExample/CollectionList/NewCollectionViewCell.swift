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
        self.backgroundColor = data.selected ? UIColor.red:UIColor.yellow;
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.contentView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
    }
    override func itemSelected() {
        super.itemSelected();
        if let  object:GeneralCellData = self.object{
            self.list?.selectAndDeselect(object);
        }
        self.list?.reloadData();
    }
}
