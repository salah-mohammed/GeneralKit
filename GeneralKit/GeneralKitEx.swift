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

 extension Array where Element == [GeneralCellData] {
//    public mutating func removeIndexPath(_ indexPath:IndexPath){
//        self[indexPath.section].bs_removeTo(index:indexPath.row)
//    }
}
 extension Array{
    func indexPaths(section:Int,_ lastIndex:Int? = nil)->[IndexPath]{
        var indexPaths:[IndexPath] = [IndexPath]()
        for object in self.enumerated(){
            indexPaths.append(IndexPath.init(row:(object.offset+(lastIndex ?? 0)), section:section))
        }
     return indexPaths
    }
}
extension Int{
 var bs_string:String{
    return String(self);
}
}

 extension Dictionary {
    mutating func bs_merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
 extension Collection {
    func bs_get(_ index: Self.Index)->Iterator.Element?{
        return self.indices.contains(index) ? self[index] : nil;
    }
    func bs_getOptional(_ index: Self.Index?)->Iterator.Element?{
        if let index:Self.Index=index{
            return bs_get(index)
        }
        return nil;
    }
    func bs_get(_ indexs: [Self.Index])->Array<Iterator.Element>{
        var items = Array<Iterator.Element>();
        for  index in indexs{
            if let item = self.bs_get(index){
                items.append(item);
            }
        }
        return items;
    }
}
public extension UIResponder {
    func bs_getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).bs_getParentViewController()
            }
            else {return nil}
        }
    }
}
