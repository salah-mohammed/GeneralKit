//
//  ValidationObject.swift
//  GraduationProject
//
//  Created by Salah on 9/21/18.
//  Copyright © 2018 Salah. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public class ValidationObject: NSObject {
public  enum  MimeType:String {
        case pdf = "application/pdf"
        case photo = "image/*"
        case audio = "audio/*"
        case video = "video/*"
        case video_mp4 = "video/mp4"
        case audio_mp3 = "audio/mp3"
    }
public class MultiPartObject
    {
        //                formData?.appendPart(withFileData: userImage?.pngData, name: "s_avatar", fileName: "photo.png", mimeType: "image/png")
        var data:Data?
        var name:String?;
        var fileName:String?;
        var mimeType:String?;
        
        
        public init(data:Data,name:String,fileName:String,mimeType:String) {
            self.data=data;
            self.name=name;
            self.fileName=fileName;
            self.mimeType=mimeType;
            
        }
    }
    
    var title:String=""
    var message:Array<String> = Array<String>()
//    var multiPartObjects:Array<MultiPartObject> = Array<MultiPartObject>()
    
    var success:Bool{
        if (message.count > 0){
            return false;}
        return true;
    }
//    var parameters:Dictionary<String,String> = Dictionary<String,String>()
    
    var printMessage:String
    {
        return message.joined(separator: "\n")
    }
//    func parameter(value:String,key:String)
//    {
//        parameters.updateValue(value, forKey: key);
//    }
    
//    func multiPartObject(object:MultiPartObject)
//    {
//        multiPartObjects.append(object);
//    }
}

public class NewBuilder<T:Mappable>:NSObject{
    public override init() {
        super.init();
    }
    public func aa(){
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        AF.request(URL).responseObject{ (response:DataResponse<T,AFError>) in
            print(response.value);
            switch response{
                
            default:
                break;
            }
        }

    }
}


