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
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationSetup();
        tableView.paginationManager(paginationManager).identifier("cell").start();
    }
    func paginationSetup(){
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            if response.value?.pagination?.i_current_page == 1{
                self.tableView.handle(itemsType: .replace(response.value?.users ?? []))
            }else{
                self.tableView.handle(itemsType: .append(response.value?.users ?? []))
            }
        }
    }

}
