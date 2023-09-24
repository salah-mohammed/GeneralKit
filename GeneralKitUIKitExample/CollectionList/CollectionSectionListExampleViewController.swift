//
//  CollectionSectionListExampleViewController.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
import SalahUtility
class CollectionSectionListExampleViewController: UIViewController {
    @IBOutlet weak var collectionView:GeneralCollectionView!
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        paginationSetup();
    }
    func setupData(){
        collectionView.selectionType = .single(optional: true)
        collectionView.containsHandler = { object1 , object2 in
            return (object1 as? User)?.id == (object2 as? User)?.id
        }
        collectionView.converterHandler { item in
            let value = (UIScreen.main.bounds.width-40)/2;
            return GeneralCellData.init(identifier:"NewCollectionViewCell", object: item,cellSize:CGSize.init(width:value, height:value))
        }
        self.collectionView.viewForSupplementaryElementHandler { kind, indexPath in
        let reusableview = self.collectionView.dequeueReusableSupplementaryView(ofKind:kind, withReuseIdentifier:"SectionHeaderCollectionView", for: indexPath) as? SectionHeaderCollectionView
            reusableview?.section = indexPath.section
            reusableview?.config();
            return reusableview ?? UICollectionReusableView();
        }
    }
    func setupView(){
        collectionView.bs_register("NewCollectionViewCell")
        collectionView.register(UINib(nibName: "SectionHeaderCollectionView", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionView")
        collectionView.register(UINib(nibName: "SectionHeaderCollectionView", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionHeaderCollectionView")
        self.collectionView.headerSize(CGSize.init(width: 200, height: 50));
        self.collectionView.footerSize(CGSize.init(width: 200, height:0));
    }
    func paginationSetup(){
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            if response.value?.pagination?.i_current_page == 1{
                self.collectionView.handleAny(.objects([response.value?.users ?? []]))
            }else{
                self.collectionView.handleAny(.appendItemsInSection(atRow:nil, response.value?.users ?? []))
            }
        }
        collectionView.paginationManager(paginationManager).identifier("NewCollectionViewCell").start();
    }
    deinit{
        print("deinit");
    }
}
