//
//  GeneralKitEx.swift
//  GeneralKit
//
//  Created by SalahMohamed on 24/10/2022.
//

import Foundation

extension Bundle {
    static var module: Bundle? = {
        //firstBundle -> this will used when libarary used in example
        if let firstBundle = Bundle(path: "\(Bundle.main.bundlePath)/Frameworks/GeneralKit.framework/GeneralKit.bundle"),FileManager.default.fileExists(atPath: firstBundle.bundlePath){
        
    return firstBundle
    }else
        //secondBundle -> this will used when libarary used in pods and add libarary as static libarary
       if let firstBundle = Bundle(path: "\(Bundle.main.bundlePath)/GeneralKit.bundle"),FileManager.default.fileExists(atPath: firstBundle.bundlePath){
    return firstBundle
    }else
        //thiredBundle -> this will used when libarary used in pods
if let secondBundle:Bundle = Bundle(path: "\(Bundle.main.bundlePath)/Frameworks/GeneralKit.framework"),FileManager.default.fileExists(atPath: secondBundle.bundlePath){
            return secondBundle;
    }
      return nil
    }()
}

public extension Array where Element == [GeneralCellData] {
    public mutating func removeIndexPath(_ indexPath:IndexPath){
        self[indexPath.section].remove(at: indexPath.row)
    }
}
public extension Array{
    func indexPaths(section:Int)->[IndexPath]{
        var indexPaths:[IndexPath] = [IndexPath]()
        for object in self.enumerated(){
            indexPaths.append(IndexPath.init(row:object.offset, section:section))
        }
     return indexPaths
    }
}
