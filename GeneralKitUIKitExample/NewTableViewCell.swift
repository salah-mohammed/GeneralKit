//
//  NewTableViewCell.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class NewTableViewCell: GeneralTableViewCell {

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
        self.accessoryType = self.object.selected  ? .checkmark:.none
    }
    open override func itemSelected() {
        super.itemSelected();
        self.list.selectAndDeselect(self.object);
        self.list.reloadData();
    }
}
