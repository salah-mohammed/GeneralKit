//
//  NotificationBuilder.swift
//  LocalNotification
//
//  Created by Salah on 5/1/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
import UserNotifications

public extension DateComponents {
    public enum DateType {
        case minutly
        case daily
        case weekly
        case date
        
        var components:Set<Calendar.Component>{
            switch self {
            case .minutly:
                return [.minute]
            case .daily:
                return [.hour, .minute, .second]
            case .weekly:
                return [.weekday, .hour, .minute, .second]
            case .date:
                return [.year, .month, .day, .hour, .minute, .second]
            }
        }
    }
}

public class NotificationBuilder:NSObject {
    public enum Trigger {
        case timeInterval(value:TimeInterval)
        case date(date:Date,dateType:DateComponents.DateType,calendar:Calendar?)
        case dateComponents(date:DateComponents)

    }
    var identifier:String!
    var title:String!;
    var subTitle:String?;
    var body:String!;
    var sound:UNNotificationSound = UNNotificationSound.default
    
    var repeats:Bool=false;
    
    var request:UNNotificationRequest?
    public var userInfo:[AnyHashable : Any]?

    var trigger:Trigger?

    public class func builder() -> NotificationBuilder {
        return NotificationBuilder()
    }
     public func build() -> Self {
        let content = UNMutableNotificationContent();
        content.title = self.title;
        content.subtitle = self.subTitle ?? "";
        content.body = self.body;
        content.sound = sound
        if let userInfo:[AnyHashable : Any] = self.userInfo {
        content.userInfo = userInfo;
        }
        //["Content-available":"1"]

        var trigger:UNNotificationTrigger?

        switch self.trigger {
        case .timeInterval(let value)?:
             trigger = UNTimeIntervalNotificationTrigger.init(timeInterval:value, repeats: self.repeats);
            break
        case .date(let date,let dateType,let calendar)?:
            let dateComponents = (calendar ?? Calendar.current).dateComponents(dateType.components, from:date);
            trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: self.repeats)
            break
            
        case .none:
            break;
        case .dateComponents(let dateComponents)?:
            trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: self.repeats)
        }
        if let trigger:UNNotificationTrigger = trigger {
        self.request = UNNotificationRequest.init(identifier:self.identifier ?? "", content: content, trigger:trigger);
        }

        return self;
    }
    public func execute(_ handler:((Error?,UNNotificationRequest?)->Void)?=nil){
        if let request:UNNotificationRequest = self.request {
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            print(error);
            handler?(error,request);
        }
        }
    }
    


    @discardableResult public func title(_ title:String)->Self{
        self.title=title;
        return self;
    }
    @discardableResult public func subTitle(_ subTitle:String)->Self{
        self.subTitle=subTitle;
        return self;
    }
   @discardableResult public func body(_ body:String)->Self{
        self.body=body;
        return self;
    }
   @discardableResult public func sound(_ sound:UNNotificationSound)->Self{
        self.sound=sound;
        return self;
    }
    
   @discardableResult public func trigger(_ trigger:Trigger)->Self{
        self.trigger=trigger;
        return self;
    }
    
   @discardableResult public func identifier(_ identifier:String)->Self{
        self.identifier=identifier;
        return self;
    }
   @discardableResult public func repeats(_ repeats:Bool)->Self{
        self.repeats=repeats;
        return self;
    }
    @discardableResult public func userInfo(_ userInfo:[AnyHashable : Any])->Self{
        self.userInfo=userInfo;
        return self;
    }
    public static func debugHandler(_ debugString:@escaping ((String)->Void)){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (pendingObjects:[UNNotificationRequest]) in
            let pendingText:String=UNUserNotificationCenter.current().debug(pendingObjects: pendingObjects);
            UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (objects:[UNNotification]) in
                let deliveredText:String=UNUserNotificationCenter.current().debug(deliveredObjects: objects);
                debugString("\(pendingText)\n\(deliveredText)") ;
            })
        }
    }
    public static func remove(identifier:String){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:[identifier]);
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier]);

    }
    public static func remove(partOfIdentifier:String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (objects:[UNNotificationRequest]) in
            
            let  objects = objects.filter({ (request:UNNotificationRequest) -> Bool in
                return request.identifier.contains(partOfIdentifier) }).map({ (request:UNNotificationRequest) -> String in
               return request.identifier
            });
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:objects);
        }
    }
    public static func remove(dic:[String:String],handler:(()->Void)?){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (objects:[UNNotificationRequest]) in
            let  objects = objects.filter({ (request:UNNotificationRequest) -> Bool in
                let identifier = request.identifier
                var contains=false;
                for (index,object) in dic.enumerated() {
                    contains=identifier.contains("\(object.key)=\(object.value)")
                    if contains == false{
                        break
                    }
                }
                return contains;
                
            }).map({ (request:UNNotificationRequest) -> String in
                return request.identifier
            });
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:objects);
            handler?();
        }
    }
   
}
public extension UNUserNotificationCenter {
    public func debug(deliveredObjects:[UNNotification])->String{
        var deliveredText:String="";
        deliveredText=deliveredObjects.map { (object:UNNotification) -> String in
            return "identifier = \(object.request.identifier)"
        }.joined(separator:",");
        deliveredText = "DeliveredNotifications="+"[\(deliveredText)]"
        return deliveredText;
    }
    public func debug(pendingObjects:[UNNotificationRequest])->String{
        var pendingText:String="";
        pendingText=pendingObjects.map { (object:UNNotificationRequest) -> String in
          return "identifier = \(object.identifier)"
        }.joined(separator:",");
        pendingText = "PendingNotification="+"[\(pendingText)]"
        return pendingText;
    }
}
