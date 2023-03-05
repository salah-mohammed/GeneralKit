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
        setupView();
        setupData();
        paginationSetup();
    }
    func setupView(){
        collectionView.bs_register("NewCollectionViewCell")
    }
    func setupData(){
        collectionView.selectionType = .multi
        collectionView.converterHandler { item in
            let value = (UIScreen.main.bounds.width-40)/2;
            return GeneralCellData.init(identifier:"NewCollectionViewCell", object: item,cellSize:CGSize.init(width:value, height:value))
        }
        collectionView.containsHandler = { object1 , object2 in
        return (object1 as? User)?.id == (object2 as? User)?.id
        }
    }
    func paginationSetup(){
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            ResponseHandler.check(response,{ baseResponse in
                
            })

            if response.value?.pagination?.i_current_page == 1{
                self.collectionView.handleAny(.objects([response.value?.users ?? []]))
            }else{
                self.collectionView.handleAny(.appendItemsInSection(atRow: nil, response.value?.users ?? []))
            }
        }
        collectionView.paginationManager(paginationManager).identifier("NewCollectionViewCell").start();
    }
}
