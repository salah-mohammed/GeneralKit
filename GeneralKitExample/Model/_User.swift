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
public class _UserRealm: PersonRealm {
     @objc dynamic var username:String?;  
     @objc dynamic var fullname:String?;  
     @objc dynamic var datebirth:Date?;  
     @objc dynamic var yearsExpere:Int = -1;
     @objc dynamic var personA1:_RoleRealm?;
     @objc dynamic var personA2:_RoleRealm?;
     var personB1:List<_RoleRealm> = List<_RoleRealm>()
     var personB2:List<_RoleRealm> = List<_RoleRealm>()
    
    public required init?(map: ObjectMapper.Map){
        super.init(map: map)
        username <- map["username"]
        fullname <- map["fullname"]
        datebirth <- map["datebirth"]
        yearsExpere <- map["yearsExpere"]
        personA1 <- map["personA1"]
        personA2 <- map["personA2"]
        personB1 <- (map["personB1"],ListTransform<_RoleRealm>())
        personB2 <- (map["personB2"],ListTransform<_RoleRealm>())
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
    
    public override func mapping(map: ObjectMapper.Map) {
          super.mapping(map:map)
          username <- map["username"]
          fullname <- map["fullname"]
          datebirth <- map["datebirth"]
          yearsExpere <- map["yearsExpere"]
          personA1 <- map["personA1"]
          personA2 <- map["personA2"]
          personB1 <- (map["personB1"],ListTransform<_RoleRealm>())
          personB2 <- (map["personB2"],ListTransform<_RoleRealm>())
    }
    
    public override func toDictionary() -> [String:Any]{
          var dictionary = super.toDictionary()

          dictionary["username"] = username
          dictionary["fullname"] = fullname
          dictionary["datebirth"] = datebirth
          dictionary["yearsExpere"] = yearsExpere

          dictionary["personA1"] =  personA1?.toDictionary()
          dictionary["personA2"] =  personA2?.toDictionary()

          var dictionarypersonB1 = [[String:Any]]()
           for obj in personB1 {
            dictionarypersonB1.append(obj.toDictionary())
            }
           dictionary["personB1"] = dictionarypersonB1

          var dictionarypersonB2 = [[String:Any]]()
           for obj in personB2 {
            dictionarypersonB2.append(obj.toDictionary())
            }
           dictionary["personB2"] = dictionarypersonB2
       
        return dictionary
    }
   
    public override var description: String{
           let stringValue = ["username =\(self.username?.description ?? "nil")",
         "fullname =\(self.fullname?.description ?? "nil")",
         "datebirth =\(self.datebirth?.description ?? "nil")",
         "yearsExpere =\(self.yearsExpere.description)",
        "personA1 =\(self.personA1?.description ?? "nil")",
         "personA2 =\(self.personA2?.description ?? "nil")",
        "personB1 =\(self.personB1.description)",
         "personB2 =\(self.personB2.description)"].joined(separator:"\n")
      return stringValue
    }
}
#endif

public class _User: Person{
     enum UserEnum:String{
       case username = "username"
       case fullname = "fullname"
       case datebirth = "datebirth"
       case yearsExpere = "yearsExpere"
       case personA1 = "personA1"
       case personA2 = "personA2"
       case personB1 = "personB1"
       case personB2 = "personB2"
       case age = "age"
       case name = "name"
       case R1 = "R1"
       case R2 = "R2"
       case B1 = "B1"
       case B2 = "B2"
      }

     var username:String?;
    var fullname:String?;
    var datebirth:Date?;
    var yearsExpere:Int?;
    var personA1:Role?;
    var personA2:Role?;
    var personB1:[Role] = [Role]()
    var personB2:[Role] = [Role]()
    
    public required init?(map: ObjectMapper.Map){
        super.init(map: map)
        username <- map["username"]
        fullname <- map["fullname"]
        datebirth <- map["datebirth"]
        yearsExpere <- map["yearsExpere"]
        personA1 <- map["personA1"]
        personA2 <- map["personA2"]
        personA1 <- map["personA1"]
        personA2 <- map["personA2"]    }
    
    public override class func primaryKey() -> String?{
        return "id"
    }
    
        public override func mapping(map: ObjectMapper.Map) {
        super.mapping(map:map)
        username <- map["username"]
        fullname <- map["fullname"]
        datebirth <- map["datebirth"]
        yearsExpere <- map["yearsExpere"]
        personA1 <- map["personA1"]
        personA2 <- map["personA2"]
        personA1 <- map["personA1"]
        personA2 <- map["personA2"]
    }
    
    @objc required public override init(coder aDecoder: NSCoder){
        super.init(coder:aDecoder)
        username = aDecoder.decodeObject(forKey:"username") as? String
        fullname = aDecoder.decodeObject(forKey:"fullname") as? String
        datebirth = aDecoder.decodeObject(forKey:"datebirth") as? Date
        yearsExpere = aDecoder.decodeObject(forKey:"yearsExpere") as? Int
        personA1 = aDecoder.decodeObject(forKey:"personA1") as? Role
        personA2 = aDecoder.decodeObject(forKey:"personA2") as? Role
        personB1 = aDecoder.decodeObject(forKey:"personB1") as? [Role] ?? [Role]()
        personB2 = aDecoder.decodeObject(forKey:"personB2") as? [Role] ?? [Role]()
    }

    @objc public override func encode(with aCoder: NSCoder){
        super.encode(with: aCoder)
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if fullname != nil{
            aCoder.encode(fullname, forKey: "fullname")
        }
        if datebirth != nil{
            aCoder.encode(datebirth, forKey: "datebirth")
        }
        if yearsExpere != nil{
            aCoder.encode(yearsExpere, forKey: "yearsExpere")
        }
        if personA1 != nil{
            aCoder.encode(personA1, forKey: "personA1")
        }
        if personA2 != nil{
            aCoder.encode(personA2, forKey: "personA2")
        }
        aCoder.encode(personB1, forKey: "personB1")
        aCoder.encode(personB2, forKey: "personB2")
    }
    
    public override func toDictionary() -> [String:Any]{
         var dictionary = super.toDictionary()

        dictionary["username"] = username
        dictionary["fullname"] = fullname
        dictionary["datebirth"] = datebirth
        dictionary["yearsExpere"] = yearsExpere
        var dictionarypersonB1 = [[String:Any]]()
        for obj in personB1 {
        dictionarypersonB1.append(obj.toDictionary())
        }
        dictionary["personB1"] = dictionarypersonB1
         var dictionarypersonB2 = [[String:Any]]()
        for obj in personB2 {
        dictionarypersonB2.append(obj.toDictionary())
        }
        dictionary["personB2"] = dictionarypersonB2
        dictionary["personA1"] =  personA1?.toDictionary()
        dictionary["personA2"] =  personA2?.toDictionary()
        return dictionary
    }
    
    public override init(fromDictionary dictionary: [String:Any]){
         super.init(fromDictionary: dictionary)
        username = dictionary["username"] as? String
        fullname = dictionary["fullname"] as? String
        if let stringdatebirth:String = dictionary["datebirth"] as? String{
            datebirth = Date.init(dateString: stringdatebirth, format: mappingDateFormate)
        }
        yearsExpere = dictionary["yearsExpere"] as? Int
         if let data = dictionary["personA1"] as? [String:Any]{
            personA1 = Role(fromDictionary: data)
         }
         if let data = dictionary["personA2"] as? [String:Any]{
            personA2 = Role(fromDictionary: data)
         }
         if let arr = dictionary["personB1"] as? [[String:Any]]{
            for dic in arr{
                let value = Role(fromDictionary: dic)
                personB1.append(value)
            }
         }
         if let arr = dictionary["personB2"] as? [[String:Any]]{
            for dic in arr{
                let value = Role(fromDictionary: dic)
                personB2.append(value)
            }
         }
     }
    
    public override var description: String{
         let stringValue = ["username =\(self.username?.description ?? "nil")",
         "fullname =\(self.fullname?.description ?? "nil")",
         "datebirth =\(self.datebirth?.description ?? "nil")",
         "yearsExpere =\(self.yearsExpere?.description ?? "nil")",
         "personA1 =\(self.personA1?.description ?? "nil")",
         "personA2 =\(self.personA2?.description ?? "nil")",
         "personB1 =\(self.personB1.description)",
         "personB2 =\(self.personB2.description)"].joined(separator:"\n")
      return stringValue
    }
}
