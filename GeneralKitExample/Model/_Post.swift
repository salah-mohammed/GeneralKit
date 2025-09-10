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
public class _PostRealm: Object,Mappable {
     @objc dynamic var userId:Int=0;
     @objc dynamic var id:Int=0;
     @objc dynamic var title:String?;
     @objc dynamic var body:String?;
     @objc dynamic var createdDate:Date?;
    
    public required init?(map: ObjectMapper.Map){
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        createdDate <- map["createdDate"]
    }
    
    public override class func primaryKey() -> String?{
        return "id"
    }
    
    public func mapping(map: ObjectMapper.Map) {
          userId <- map["userId"]
          id <- map["id"]
          title <- map["title"]
          body <- map["body"]
          createdDate <- map["createdDate"]
    }
    
    public func toDictionary() -> [String:Any]{
          var dictionary = [String:Any] ()
          dictionary["userId"] = userId
          dictionary["id"] = id
          dictionary["title"] = title
          dictionary["body"] = body
          dictionary["createdDate"] = createdDate
       
        return dictionary
    }
   
    public override var description: String{
           let stringValue = ["userId =\(self.userId.description)",
         "id =\(self.id.description)",
         "title =\(self.title?.description ?? "nil")",
         "body =\(self.body?.description ?? "nil")",
         "createdDate =\(self.createdDate?.description ?? "nil")"].joined(separator:"\n")
      return stringValue
    }
}
#endif

public class _Post: NSObject,Mappable,NSCoding{
     enum UserEnum:String{
       case userId = "userId"
       case id = "id"
       case title = "username"
       case body = "fullname"
       case createdDate = "datebirth"
      }
    var userId:Int=0;
    var id:Int=0;
    var title:String?;
    var body:String?;
    var createdDate:Date?;
    
    public required init?(map: ObjectMapper.Map){
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        createdDate <- map["createdDate"]
    }
    
    public class func primaryKey() -> String?{
        return "id"
    }
    
        public func mapping(map: ObjectMapper.Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        createdDate <- map["createdDate"]
    }
    
    @objc required public init(coder aDecoder: NSCoder){
        userId = aDecoder.decodeObject(forKey:"userId") as? Int ?? 0
        id = aDecoder.decodeObject(forKey:"id") as? Int ?? 0
        title = aDecoder.decodeObject(forKey:"title") as? String
        body = aDecoder.decodeObject(forKey:"body") as? String
        createdDate = aDecoder.decodeObject(forKey:"createdDate") as? Date
    }

    @objc public func encode(with aCoder: NSCoder){
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(id, forKey: "id")

        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if body != nil{
            aCoder.encode(body, forKey: "body")
        }
        if createdDate != nil{
            aCoder.encode(createdDate, forKey: "createdDate")
        }
    }
    
    public func toDictionary() -> [String:Any]{
        var dictionary = [String:Any] ()
        dictionary["userId"] = userId
        dictionary["id"] = id
        dictionary["title"] = title
        dictionary["body"] = body
        dictionary["createdDate"] = createdDate
        return dictionary
    }
    
    public init(fromDictionary dictionary: [String:Any]){
        userId = dictionary["userId"] as? Int ?? 0
        id = dictionary["id"] as? Int ?? 0
        title = dictionary["title"] as? String
        body = dictionary["body"] as? String
        if let stringdatebirth:String = dictionary["createdDate"] as? String{
            createdDate = Date.init(dateString: stringdatebirth, format: mappingDateFormate)
        }
     }
    
    public override var description: String{
         let stringValue = ["userId =\(userId),id =\(id),title =\(self.title?.description ?? "nil")",
         "body =\(self.body?.description ?? "nil")",
         "createdDate =\(self.createdDate?.description ?? "nil")"].joined(separator:"\n")
      return stringValue
    }
}
