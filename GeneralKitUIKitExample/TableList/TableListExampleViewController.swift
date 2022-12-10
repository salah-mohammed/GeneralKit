//
//  TableListExampleViewController.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 17/10/2022.
//

import UIKit
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class TableListExampleViewController: UIViewController {
    @IBOutlet weak var tableView:GeneralTableView!
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.bs_registerNib(NibName:"NewTableViewCell");
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationSetup();
        tableView.paginationManager(paginationManager).identifier("NewTableViewCell").start();
    }
    func paginationSetup(){
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            ResponseHandler.check(response,{ baseResponse in
                
            })

            if response.value?.pagination?.i_current_page == 1{
                self.tableView.handle(.any(.objects([response.value?.users ?? []])),response.error)
            }else{
                self.tableView.handle(.any(.appendItemsInSection(atRow: nil,response.value?.users ?? [])),response.error)
            }
        }
    }

}

