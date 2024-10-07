/************************* Salah Mohammed *************************/
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to machine.stencil instead.
// Genrate by Genrator App (https://itunes.apple.com/app/id6502918409)
// Developer linked in https://www.linkedin.com/in/salah-mohamed-676b6a17a/

import UIKit
import ObjectMapper
import DateToolsSwift
#if canImport(RealmSwift)
import RealmSwift
import ObjectMapper_Realm
#endif

#if canImport(RealmSwift)
public class _RoleRealm: Object,Mappable {
     @objc dynamic var a:Int = -1;
    
    required public init?(map: ObjectMapper.Map){
        a <- map["a"]
   }
    
    public override class func primaryKey() -> String?{
        return "id"
    }
    public func mapping(map: ObjectMapper.Map) {
        a <- map["a"]
    }
    
    public func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        dictionary["a"] = a        
        return dictionary
    }

    public override var description: String{
      let stringValue = ["a =\(self.a.description)"].joined(separator:"\n")
      return stringValue
    }
}
#endif

public class _Role: NSObject,Mappable,NSCoding{
     enum RoleEnum:String{
       case a = "a"
      }

    var a:Int?;
    
    required public init?(map: ObjectMapper.Map){   
        a <- map["a"]
    }
    
    public class func primaryKey() -> String?{
        return "id"
    }
    
    public func mapping(map: ObjectMapper.Map) {
        a <- map["a"]
    }
    
    @objc required public init(coder aDecoder: NSCoder){
        a = aDecoder.decodeObject(forKey:"a") as? Int
    }

    @objc public func encode(with aCoder: NSCoder){
         if a != nil{
            aCoder.encode(a, forKey: "a")
        }
    }
    
    public func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()

        dictionary["a"] = a
        return dictionary
    }
    
    public init(fromDictionary dictionary: [String:Any]){
         a = dictionary["a"] as? Int
     }
    
    public override var description: String{
      let stringValue = ["a =\(self.a?.description ?? "nil")"].joined(separator:"\n")
      return stringValue
    }
}
