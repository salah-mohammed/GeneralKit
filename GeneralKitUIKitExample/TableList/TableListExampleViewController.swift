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
    @IBOutlet weak var tableView:GeneralTableView?
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.bs_registerNib(NibName:"NewTableViewCell");
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationSetup();
        tableView?.paginationManager(paginationManager).identifier("NewTableViewCell").start();
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    deinit{
        print("deinit");
    }
    func paginationSetup(){
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { [weak self] response in
            if response.value?.pagination?.i_current_page == 1{
                self?.tableView?.handleAny(.objects([response.value?.users ?? []]),response.error)
            }else{
                self?.tableView?.handleAny(.appendItemsInSection(atRow: nil,response.value?.users ?? []),response.error)
            }
        }
    }

}

