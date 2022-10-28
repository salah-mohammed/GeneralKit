//
//  NewCollectionViewCell.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class NewCollectionViewCell:GeneralCollectionViewCell {
    override func config(){
        super.config();
        self.backgroundColor = self.object.selected ? UIColor.red:UIColor.yellow;
    }
    override func itemSelected() {
        super.itemSelected();
        self.list.selectAndDeselect(self.object);
        self.list.reloadData();
    }
}
