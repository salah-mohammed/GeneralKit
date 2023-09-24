//
//  TableSectionView.swift
//  firstTeacher
//
//  Created by Salah on 10/28/18.
//  Copyright © 2018 Newline. All rights reserved.
//

import UIKit
import GeneralKit
class TableSectionView:UIView{
    @IBOutlet weak var lblSectionName: UILabel!
    class func instanceFromNib() -> TableSectionView {
        let myView = Bundle.main.loadNibNamed("TableSectionView", owner: nil, options: nil)![0] as! TableSectionView
        return myView;
    }
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    override func layoutSubviews() {
        super.layoutSubviews();
    }
}



final class TableSectionViewHeader: UITableViewHeaderFooterView,GeneralTableViewSectionProtocol {
    var section: Int?{
        didSet{
            sectionView?.lblSectionName?.text = "Section \( self.section?.bs_string ?? "")"
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int){
        self.section = section
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        self.section = section
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        self.section = section
    }
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int){
        self.section = section
    }
    
    static let reuseIdentifier: String = String(describing: self)
    var sectionView: TableSectionView!
    var tableView: GeneralTableView!

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        sectionView = TableSectionView.instanceFromNib()
        sectionView.translatesAutoresizingMaskIntoConstraints = false

        sectionView!.frame = bounds
        // Adding custom subview on top of our view
        contentView.addSubview(sectionView!)
        self.sectionView!.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": sectionView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": sectionView]))
    }
    override func layoutSubviews() {
        super.layoutSubviews();

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
