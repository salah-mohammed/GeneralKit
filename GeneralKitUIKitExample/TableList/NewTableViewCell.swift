//
//  NewTableViewCell.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class NewTableViewCell: GeneralTableViewCell {
    @IBOutlet weak var lblSubtitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func config(_ indexPath: IndexPath,
                         _ data:GeneralCellData) {
        super.config(indexPath,data);
        self.accessoryType = self.object?.selected ?? false  ? .checkmark:.none
        self.lblSubtitle.text = (data.object as? String) ?? (data.object as? User)?.username ?? ""
    }
    open override func itemSelected() {
        super.itemSelected();
        if let object:GeneralCellData = self.object{
        self.list?.selectAndDeselect(object);
        }
        self.list?.reloadData();
    }
    @IBAction func btnDelete(_ sender:Any?){
        if let indexPath:IndexPath = self.indexPath{
        self.list?.handleRemove([indexPath])
        }
    }
}
