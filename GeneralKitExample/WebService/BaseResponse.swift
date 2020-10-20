//
//  BaseResponseAlamofire.swift
//  EnnerVoice
//
//  Created by Salah on 9/11/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class BaseResponse:NSObject,Mappable {
    var error: ResponseError?
    var data:BaseData?
//    var job:Job?
//    var jobsList:[Job] = [Job]();
//
//    var dataValue:Any?
//
//    var user:UserRealm?
    

//      var cityList:List<CityRealm> = List<CityRealm>(){
//        didSet{
//
//        }
//    }
//    var educationList:List<EducationRealm> = List<EducationRealm>(){
//        didSet{
//
//        }
//    }
//    var nationalityList:List<NationalityRealm> = List<NationalityRealm>(){
//        didSet{
//        }
//
//    }
//    var pageList:List<PageRealm> = List<PageRealm>(){
//        didSet{
//        }
//    }
//    var wishList:List<WishRelam> = List<WishRelam>(){
//        didSet{
//        }
//
//    }
    

    
    required init?(map: Map){
        error    <- map["error"]
        data    <- map["data"]
        
        
//        user    <- map["data"]
//        cityList    <- (map["data"],ListTransform<CityRealm>())
//        educationList    <- (map["data"],ListTransform<EducationRealm>())
//        nationalityList    <- (map["data"],ListTransform<NationalityRealm>())
//        pageList    <- (map["data"],ListTransform<PageRealm>())

        data     <- map["data"]
//        dataValue     <- map["data"]
//        job     <- map["data"]
//        wishList    <- (map["data"],ListTransform<WishRelam>())
//        jobsList     <- map["data"]


    }
    
    func mapping(map: Map) {
        error    <- map["error"]
        data    <- map["data"]
        
        
//        user    <- map["data"]
//        cityList    <- (map["data"],ListTransform<CityRealm>())
//        educationList    <- (map["data"],ListTransform<EducationRealm>())
//        nationalityList    <- (map["data"],ListTransform<NationalityRealm>())
//        pageList    <- (map["data"],ListTransform<PageRealm>())

        data     <- map["data"]
//        dataValue     <- map["data"]
//        job     <- map["data"]
//        wishList    <- (map["data"],ListTransform<WishRelam>())
//        jobsList     <- map["data"]

    }
    
    
    //Reactive<Self>.Type
    
//    func commit(_ route:(BaseResponse) -> List<Object>.CompatibleType){
//        let realm = try! Realm()
//        try! realm.write {
//            let object: List<Object> = route(self) as! List<Object>
//            if object.count >= 0{
//                realm.add(object as! Object, update: true);
//
//            }
//        }
//    }
//
//
//    func commit(_ route:(BaseResponse) -> Object.CompatibleType?){
//        let realm = try! Realm()
//        try! realm.write {
//            let object = route(self);
//            if object != nil {
//                realm.add(object! as! Object, update: true);
//            }
//        }
//
//    }
}



