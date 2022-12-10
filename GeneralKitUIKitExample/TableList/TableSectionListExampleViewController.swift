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
        self.tableView.listType = .section
        self.tableView.selectionType = .single(optional:true)
        self.tableView.bs_registerNib(NibName:"NewTableViewCell");
        
        self.tableView.containsHandler = { object1,object2 in
        return (object1 as! String) == (object2 as! String)
        }
        self.tableView.sectionViewHandler = { section in
            var a = UIView.init()
            a.backgroundColor=UIColor.red
            return a
        }
        self.tableView.sectionHeightHandler = { section in
          return 20
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

        
        tableView.handle(.data(.objects([section0])))
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.tableView.handle(.data(.appendNewSection(0, section1)))
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.tableView.handle(.data(.appendNewSection(0, section2)))
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.tableView.handle(.data(.appendNewSection(0, section3)))
                    
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
