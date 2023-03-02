//
//  SectionHeaderCollectionView.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 28/10/2022.
//

import UIKit
import GeneralKit
class SectionHeaderCollectionView: UICollectionReusableView,ListSectionProtocol {
    var section: Int?

    @IBOutlet weak var lblTitle:UILabel!
    func config(){
        self.lblTitle.text="Section \(section ?? 0)"
    }
}
