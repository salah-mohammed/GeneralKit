//
//  NewCollectionViewCell.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class NewCollectionViewCell:GeneralCollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgSelect: UIImageView!
    override func config(_ indexPath: IndexPath,
                         _ data:GeneralCellData?) {
        super.config(indexPath, data)
        self.imgSelect.image = data?.selected ?? false ? UIImage(named:"ic_checked"):UIImage(named:"ic_not_checked")
        lblTitle.text = (data?.object as? User)?.id.stringValue ?? ""
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.contentView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
    }
    override func itemSelected(_ indexPath:IndexPath,
                               _ data: GeneralCellData?) {
        super.itemSelected(indexPath,data);
        selection(data);
    }
    @IBAction func btnSelect(_ sender: Any) {
        selection(self.object);
    }
    func selection(_ object: GeneralCellData?){
        if let  object:GeneralCellData = object{
            self.list?.selectAndDeselect(object);
        }
        self.list?.reloadData();
    }
}
