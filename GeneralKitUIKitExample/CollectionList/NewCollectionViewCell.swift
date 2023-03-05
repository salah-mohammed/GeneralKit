//
//  NewCollectionViewCell.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class NewCollectionViewCell:GeneralCollectionViewCell {
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgSelect: UIImageView!
    override func config(_ indexPath: IndexPath,
                         _ data:GeneralCellData) {
        super.config(indexPath, data)
        self.imgSelect.image = data.selected ? UIImage(named:"ic_checked"):UIImage(named:"ic_not_checked")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.contentView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
    }
    override func itemSelected() {
        super.itemSelected();
        selection();
    }
    @IBAction func btnSelect(_ sender: Any) {
        selection();
    }
    func selection(){
        if let  object:GeneralCellData = self.object{
            self.list?.selectAndDeselect(object);
        }
        self.list?.reloadData();
    }
}
