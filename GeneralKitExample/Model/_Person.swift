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
public class _PersonRealm: Object,Mappable {
     @objc dynamic var age:NSNumber?;  
     @objc dynamic var name:String?;
     @objc dynamic var R1:_RoleRealm?;
     @objc dynamic var R2:_RoleRealm?;
     var B1:List<_RoleRealm> = List<_RoleRealm>()
     var B2:List<_RoleRealm> = List<_RoleRealm>()
    
    required public init?(map: ObjectMapper.Map){
        age <- map["age"]
        name <- map["name"]
        R1 <- map["R1"]
        R2 <- map["R2"]
        B1 <- (map["B1"],ListTransform<_RoleRealm>())
        B2 <- (map["B2"],ListTransform<_RoleRealm>())
   }
    
    public override class func primaryKey() -> String?{
        return "id"
    }
    public func mapping(map: ObjectMapper.Map) {
        age <- map["age"]
        name <- map["name"]
        R1 <- map["R1"]
        R2 <- map["R2"]
        B1 <- (map["B1"],ListTransform<_RoleRealm>())
        B2 <- (map["B2"],ListTransform<_RoleRealm>())
    }
    
    public func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        dictionary["age"] = age
         dictionary["name"] = name

         dictionary["R1"] =  R1?.toDictionary()
         dictionary["R2"] =  R2?.toDictionary()

         var dictionaryB1 = [[String:Any]]()
        for obj in B1 {
            dictionaryB1.append(obj.toDictionary())
            }
        dictionary["B1"] = dictionaryB1

       var dictionaryB2 = [[String:Any]]()
        for obj in B2 {
            dictionaryB2.append(obj.toDictionary())
            }
        dictionary["B2"] = dictionaryB2        
        return dictionary
    }

    public override var description: String{
      let stringValue = ["age =\(self.age?.description ?? "nil")",
         "name =\(self.name?.description ?? "nil")",
         "R1 =\(self.R1?.description ?? "nil")",
         "R2 =\(self.R2?.description ?? "nil")",
         "B1 =\(self.B1.description)",
         "B2 =\(self.B2.description)"].joined(separator:"\n")
      return stringValue
    }
}
#endif

public class _Person: NSObject,Mappable,NSCoding{
     enum PersonEnum:String{
       case age = "age"
       case name = "name"
       case R1 = "R1"
       case R2 = "R2"
       case B1 = "B1"
       case B2 = "B2"
      }

    var age:NSNumber?;
    var name:String?;
    var R1:Role?;
    var R2:Role?;
    var B1:[Role] = [Role]()
    var B2:[Role] = [Role]()
    
    required public init?(map: ObjectMapper.Map){   
        age <- map["age"]
        name <- map["name"]
        R1 <- map["R1"]
        R2 <- map["R2"]
        R1 <- map["R1"]
        R2 <- map["R2"]
    }
    
    public class func primaryKey() -> String?{
        return "id"
    }
    
    public func mapping(map: ObjectMapper.Map) {
        age <- map["age"]
        name <- map["name"]
        R1 <- map["R1"]
        R2 <- map["R2"]
        R1 <- map["R1"]
        R2 <- map["R2"]
    }
    
    @objc required public init(coder aDecoder: NSCoder){
        age = aDecoder.decodeObject(forKey:"age") as? NSNumber
        name = aDecoder.decodeObject(forKey:"name") as? String
        R1 = aDecoder.decodeObject(forKey:"R1") as? Role
        R2 = aDecoder.decodeObject(forKey:"R2") as? Role
        B1 = aDecoder.decodeObject(forKey:"B1") as? [Role] ?? [Role]()
        B2 = aDecoder.decodeObject(forKey:"B2") as? [Role] ?? [Role]()
    }

    @objc public func encode(with aCoder: NSCoder){
         if age != nil{
            aCoder.encode(age, forKey: "age")
        }
         if name != nil{
            aCoder.encode(name, forKey: "name")
        }
         if R1 != nil{
            aCoder.encode(R1, forKey: "R1")
        }
         if R2 != nil{
            aCoder.encode(R2, forKey: "R2")
        }
                     aCoder.encode(B1, forKey: "B1")
                     aCoder.encode(B2, forKey: "B2")
    }
    
    public func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()

        dictionary["age"] = age
        dictionary["name"] = name
        var dictionaryB1 = [[String:Any]]()
        for obj in B1 {
            dictionaryB1.append(obj.toDictionary())
        }
        dictionary["B1"] = dictionaryB1
        var dictionaryB2 = [[String:Any]]()
        for obj in B2 {
            dictionaryB2.append(obj.toDictionary())
        }
        dictionary["B2"] = dictionaryB2
        dictionary["R1"] =  R1?.toDictionary()
        dictionary["R2"] =  R2?.toDictionary()
        return dictionary
    }
    
    public init(fromDictionary dictionary: [String:Any]){
         age = dictionary["age"] as? NSNumber
        name = dictionary["name"] as? String
        if let data = dictionary["R1"] as? [String:Any]{
            R1 = Role(fromDictionary: data)
        }
        if let data = dictionary["R2"] as? [String:Any]{
            R2 = Role(fromDictionary: data)
        }
        if let arr = dictionary["B1"] as? [[String:Any]]{
            for dic in arr{
                let value = Role(fromDictionary: dic)
                B1.append(value)
            }
        }
        if let arr = dictionary["B2"] as? [[String:Any]]{
            for dic in arr{
                let value = Role(fromDictionary: dic)
                B2.append(value)
            }
        }
     }
    
    public override var description: String{
      let stringValue = ["age =\(self.age?.description ?? "nil")",
         "name =\(self.name?.description ?? "nil")",
         "R1 =\(self.R1?.description ?? "nil")",
         "R2 =\(self.R2?.description ?? "nil")",
         "B1 =\(self.B1.description)",
         "B2 =\(self.B2.description)"].joined(separator:"\n")
      return stringValue
    }
}
