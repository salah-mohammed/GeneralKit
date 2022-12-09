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
    override func config(){
        super.config();
        self.accessoryType = self.object?.selected ?? false  ? .checkmark:.none
        self.lblSubtitle.text = (self.object?.object as? String) ?? ""
    }
    open override func itemSelected() {
        super.itemSelected();
        if let object:GeneralCellData = self.object{
        self.list.selectAndDeselect(object);
        }
        self.list.reloadData();
    }
    @IBAction func btnDelete(_ sender:Any?){
    (self.list as? GeneralTableView)?.handleRemove([indexPath])
    }
}
