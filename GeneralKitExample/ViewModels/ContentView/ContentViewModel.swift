//
//  File.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ContentViewModel:NSObject,ObservableObject{
    override init() {
        super.init();
        requestOperationBuilder();        
    }
    func requestOperationBuilder(){
//        RequestOperationBuilder<WeatherResponse>.init().baseRequest(NewRequest.init(.firstRequest(s_phone: nil))).build().responseHandler({ response in
//            CutomResponseHandler<WeatherResponse>().responseHandler()
//            print(response.error);
//            print(response.value?.threeDayForecast ?? []);
//            print(response.value?.location ?? "");
//
//        }).execute()
    }
}
open class WeatherResponse:BaseModel {
    var location: String?
    var threeDayForecast: [Forecast]?
    
    open override func mapping(map: ObjectMapper.Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

public class Forecast:BaseModel {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    open override func mapping(map: ObjectMapper.Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}
