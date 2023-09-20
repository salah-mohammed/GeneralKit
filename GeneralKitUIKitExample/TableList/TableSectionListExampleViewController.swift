//
//  TableSectionListExampleViewController.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 27/10/2022.
//

import UIKit
import GeneralKit
class TableSectionListExampleViewController: UIViewController {
    @IBOutlet weak var tableView:GeneralTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView();
        setupView();
        setupData();
    }
    
    func setupView(){
        self.tableView.register(TableSectionViewHeader.self, forHeaderFooterViewReuseIdentifier:"TableSectionViewHeader")
        self.tableView.bs_registerNib(NibName:"NewTableViewCell");
//        self.tableView.heightForHeaderInSectionHandler = { [weak self] section in
//          return 50
//        }
        self.tableView.sectionViewHandler = { section in
            let cell = self.tableView!.dequeueReusableHeaderFooterView(withIdentifier:"TableSectionViewHeader") as! TableSectionViewHeader
            cell.tableView=self.tableView
            cell.section = section
            return cell
        }
    }
    func setupData(){
        self.tableView.selectionType = .single(optional:false)
        self.tableView.enablePullToRefresh=false
        self.tableView.containsHandler = { object1,object2 in
        return (object1 as! String) == (object2 as! String)
        }
        
        var section0 = [GeneralCellData.init(identifier:"NewTableViewCell", object:"1"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"2"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"3"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"4"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"5"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"6"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"7"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"8"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"9"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"10"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"11"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"12")]
        var section1 = [GeneralCellData.init(identifier:"NewTableViewCell", object:"13"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"14"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"15")]
        var section2 = [GeneralCellData.init(identifier:"NewTableViewCell", object:"16"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"17"),
                        GeneralCellData.init(identifier:"NewTableViewCell", object:"18")]
//        let cell =  GeneralCellData.init(identifier:"NewTableViewCell", object:"19");
        var section3 = [GeneralCellData.init(identifier:"NewTableViewCell", object:"19"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"20"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"21")]

        var appendToSection0 = [GeneralCellData.init(identifier:"NewTableViewCell", object:"22"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"23"),
                         GeneralCellData.init(identifier:"NewTableViewCell", object:"24")]
        
        
        tableView.handleData(.objects([section0]))
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.tableView.handleData(.appendNewSection(0, section1))
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.tableView.handleData(.appendNewSection(0, section2))
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.tableView.handleData(.appendNewSection(0, section3))
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        self.tableView.handleData(.appendItemsInSection(atRow:0, appendToSection0))
                    })
                    
                })
            })
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
