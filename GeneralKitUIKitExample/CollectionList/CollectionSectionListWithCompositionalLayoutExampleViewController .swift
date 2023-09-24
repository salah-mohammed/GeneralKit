//
//  CollectionSectionListWithCompositionalLayoutExampleViewController .swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
import SalahUtility
class CollectionSectionListWithCompositionalLayoutExampleViewController : UIViewController {
    @IBOutlet weak var collectionView:GeneralCollectionView!
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        paginationSetup();
        self.collectionView.collectionViewLayout = createCompositionalLayout()
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
        self.collectionView.viewForSupplementaryElementHandler { [weak self] kind, indexPath in
            if indexPath.section == 0{
                
            }else{
                
            }
        let reusableview = self?.collectionView.dequeueReusableSupplementaryView(ofKind:kind, withReuseIdentifier:"SectionHeaderCollectionView", for: indexPath) as? SectionHeaderCollectionView
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
                self.paginationManager.responseHandler {[weak self] response in
                    if response.value?.pagination?.i_current_page == 1{
                    self?.collectionView.handleAny(.objects([["","","",""],["","","",""],
                                                                ["","","",""],["","","",""],
                                                                ["","","",""],["","","",""],
                                                                ["","","",""],["","","",""],[]]))
                        self?.collectionView?.handleAny(.appendItemsInSection(section:8,atRow:nil,response.value?.users ?? []),response.error,false)
                        self?.collectionView.reloadData()
                    }else{
                        self?.collectionView?.handleAny(.appendItemsInSection(section:8,atRow:nil,response.value?.users ?? []),response.error,false)
                        self?.collectionView.reloadData()
                    }
                }
                collectionView.paginationManager(paginationManager).identifier("NewCollectionViewCell").start();

    }
    deinit{
        print("deinit");
    }
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, env) -> NSCollectionLayoutSection? in
            switch sectionIndex{
            case 0 : return UICollectionViewLayout.createHeaderSection()
            case 1   : return UICollectionViewLayout.createOfferSliderSection()
            case 2      : return UICollectionViewLayout.createSectionsSection()
            case 3 : return UICollectionViewLayout.createSectionsImageSection()
            case 4  : return UICollectionViewLayout.createSectionsNameSection()
            case 5      : return UICollectionViewLayout.createTopRatedSection()
            case 6        : return UICollectionViewLayout.createLatestSection()
            case 7       : return UICollectionViewLayout.createPopularSection()
            case 8    : return UICollectionViewLayout.createRandomSection()
            case 9    : return UICollectionViewLayout.createRandomListSection()
            default:
            return UICollectionViewLayout.createOfferSliderSection()
            }
        }, configuration: config)
        layout.register(SectionHeaderCollectionView.self, forDecorationViewOfKind: "SectionHeaderCollectionView")

        return layout
    }
}

/*
 
 */

extension UICollectionViewLayout {
    
    static func createHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(1), heightDimension: .absolute(0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(1), heightDimension: .absolute(0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(66))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementariesFollowContentInsets  = true
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    static func createOfferSliderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(26))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
    
    static func createSectionsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(86))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
        section.supplementariesFollowContentInsets  = false
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func createSectionsImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 7, bottom: 10, trailing: 7)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .fractionalHeight(0.34))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.supplementariesFollowContentInsets  = false
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func createSectionsNameSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.supplementariesFollowContentInsets  = false
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func createTopRatedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 20, leading: 10, bottom: 10, trailing: 10)
        section.supplementariesFollowContentInsets  = false
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func makeBackgroundDecorationItem() -> NSCollectionLayoutDecorationItem {
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "SectionHeaderCollectionView")
        backgroundItem.contentInsets = .init(top: -14, leading: 0, bottom: -2, trailing: 0)
        return backgroundItem
    }
    
    static func createLatestSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(270))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(270))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 20, leading: 10, bottom: 10, trailing: 10)
        section.supplementariesFollowContentInsets  = false
        section.decorationItems = [makeBackgroundDecorationItem()]
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func createPopularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(306), heightDimension: .absolute(430))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(306), heightDimension: .absolute(430))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 20, leading: 10, bottom: 10, trailing: 10)
        section.supplementariesFollowContentInsets  = false
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func createRandomSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 7, bottom: 8, trailing: 7)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(270))
        let group = NSCollectionLayoutGroup.horizontal( layoutSize: groupSize,subitem: item,count: 2)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 0, trailing: 14)
        section.boundarySupplementaryItems = [header]
        section.supplementariesFollowContentInsets = false
        return section
    }
    
    static func createRandomListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(106))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(106))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.supplementariesFollowContentInsets = false
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 70, trailing: 20)
        return section
    }
}
