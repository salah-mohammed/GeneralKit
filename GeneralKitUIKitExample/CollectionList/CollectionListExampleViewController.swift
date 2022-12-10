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
//        collectionView.register(UINib(nibName: "SectionHeaderCollectionView", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionView")
        collectionView.bs_register("NewCollectionViewCell")
        collectionView.selectionType = .non
//        collectionView.containsHandler = { object1 , object2 in
//            return (object1 as? User)?.id == (object2 as? User)?.id
//        }
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationSetup();
        collectionView.paginationManager(paginationManager).identifier("NewCollectionViewCell").start();
        collectionView.converterHandler { item in
            return GeneralCellData.init(identifier:"NewCollectionViewCell", object: item,cellSize:CGSize.init(width:50, height: 50))
        }
    }
    func paginationSetup(){
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            ResponseHandler.check(response,{ baseResponse in
                
            })

            if response.value?.pagination?.i_current_page == 1{
                self.collectionView.handle(.any(.objects([response.value?.users ?? []])))
            }else{
                self.collectionView.handle(.any(.appendItemsInSection(atRow: nil, response.value?.users ?? [])))
            }
        }
    }
}
