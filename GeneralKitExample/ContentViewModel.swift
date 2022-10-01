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
class AppBaseRequest:BaseRequest{
override var baseUrl:String{
return  "https://raw.githubusercontent.com"
}
override var token:String?{
return nil;
}
}
class NewRequest:AppBaseRequest{
    public enum Route{
        case firstRequest(s_phone:String?)
        case secondRequest(s_phone:String?)
    }
    private var route:Route
    init(_ route:Route) {
        self.route = route
    }
    override var path:String?{
        switch self.route{
        case .firstRequest(_):
            break;
        case .secondRequest(_):
            break;
        }
        return "/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json";
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Dictionary<String,String>{
       var parameters =  super.parameters
//        switch self.route{
//        case .firstRequest(_):
//            break;
//        case .secondRequest(_):
//            break;
//        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
//        switch self.route{
//        case .firstRequest(_):
//            break;
//        case .secondRequest(_):
//            break;
//        }
        return .get
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
//        switch self.route{
//        case .firstRequest(_):
//            break;
//        case .secondRequest(_):
//            break;
//        }
        let items = [ValidationObject.MultiPartObject]();
        return items
    }
}
class ContentViewModel:NSObject,ObservableObject{
    var paginationManager:PaginationManager<WeatherResponse>=PaginationManager<WeatherResponse>.init()
    override init() {
        super.init();
        requestOperationBuilder();
        paginationManagerHandlers();
        
    }
    func paginationManagerHandlers(){
        self.paginationManager.responseHandler { response in
            
        }
        self.paginationManager.hasNextPageHandler { response in
          return true
        }
        self.paginationManager.currentPageHandler { response in
            return 1;
        }
        self.paginationManager.hasPreviousPageHandler { response in
            return true
        }
    }
    
    func requestOperationBuilder(){
        RequestOperationBuilder<WeatherResponse>.init().baseRequest(NewRequest.init(.firstRequest(s_phone: nil))).build().responseHandler({ response in
            ResponseHandler<WeatherResponse>().responseHandler()
            print(response.error);
            print(response.value?.threeDayForecast ?? []);
            print(response.value?.location ?? "");

        }).execute()
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
