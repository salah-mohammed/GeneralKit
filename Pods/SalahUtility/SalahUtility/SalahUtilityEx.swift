//
//  SalahUtilityEx.swift
//  SalahUtility
//
//  Created by Salah on 7/10/21.
//  Copyright © 2021 Salah. All rights reserved.
//

import Foundation
extension String{
     var internalLocalize_ : String {
        return NSLocalizedString(self, tableName: nil, bundle:Bundle.framwWorkBundle ?? Bundle.main, value: "", comment: "")
    }
}
extension Bundle{
    class var framwWorkBundle:Bundle?{
        let podBundle = Bundle(for: LocalAuth.self)
        if let bundleURL:URL = podBundle.url(forResource: "SalahUtility", withExtension: "bundle"){
        return Bundle(url: bundleURL)
        }
        return podBundle;
    }
}
