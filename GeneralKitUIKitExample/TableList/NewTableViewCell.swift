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
                         _ data:GeneralCellData?) {
        super.config(indexPath,data);
        self.accessoryType = (data?.selected ?? false) ? .checkmark:.none
        if let user:User = data?.object as? User{
            self.lblSubtitle.text = (indexPath.row+1).bs_string+" "+(user.username ?? "")

        }else{
            self.lblSubtitle.text = (data?.object as? String) ?? ""
        }
    }
    open override func itemSelected(_ indexPath:IndexPath,
                                    _ data: GeneralCellData?) {
        super.itemSelected(indexPath, data);
        if let object:GeneralCellData = data{
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
