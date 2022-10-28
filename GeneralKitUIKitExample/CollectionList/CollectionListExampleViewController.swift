//
//  CollectionListExampleViewController.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
import SalahUtility
class CollectionListExampleViewController: UIViewController {
    @IBOutlet weak var collectionView:GeneralCollectionView!
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.bs_register("NewCollectionViewCell")
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationSetup();
        collectionView.paginationManager(paginationManager).identifier("NewCollectionViewCell").start();
        
    }
    func paginationSetup(){
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            if response.value?.pagination?.i_current_page == 1{
                self.collectionView.handle(itemsType: .new(response.value?.users ?? []))
            }else{
                self.collectionView.handle(itemsType: .append(response.value?.users ?? []))
            }
        }
    }
}
