//
//  BaseExtension.swift
//  Test1
//
//  Created by Salah on 12/15/19.
//  Copyright © 2019 Salah. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif
#if os(OSX)
import Cocoa
#endif
import MapKit
import AudioToolbox
import AVKit
import MediaPlayer
import AVFoundation
import Photos
import UserNotifications
import MediaPlayer
import SwiftUI
import SafariServices
//import CommonCrypto
//    #if os(iOS) || os(watchOS) || os(tvOS)
//        let color = UIColor.red
//    #elseif os(macOS)
//        let color = NSColor.red
//    #else
//        println("OMG, it's that mythical new Apple product!!!")
//    #endif
/*    **Array**   */

public enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        @available(iOS 13.0, *)
        case soft
        @available(iOS 13.0, *)
        case rigid
        case selection
        case oldSchool

        public func vibrate() {
            switch self {
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .light:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case .medium:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case .heavy:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case .soft:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            case .selection:
                UISelectionFeedbackGenerator().selectionChanged()
            case .oldSchool:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
public extension CLLocationCoordinate2D{
    var stringValue:String{
        let latitude = String.init(format:"%.6f", self.latitude)
        let longitude = String.init(format:"%.6f", self.longitude)
        return "(\(latitude),\(longitude))";
    }
}
public enum RegularExpression:String{
    case email="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone = "[+]+[0-9 ]{1,}|[00]+[0-9 ]{1,}|[0-9 ]{9,}"
    case empty="^[. ]*$"
    public var regex:Regex{
        return Regex.init(self.rawValue);
    }
    public func  matches(_ input:String)->Bool{
    return self.regex.matches(input:input)
    }
}

#if os(iOS)
public enum DeviceSize{
    // se,8,8+
case old
    // 12 pro max,13 pro
case new
    // ipad
case ipad
    static var all:[DeviceSize] {
        return [.old,.new,.ipad]
    }
    var devices:[DeviceType]{
        switch self{
        case .old:
            return [.iphone8,.iphone8Plus]
        case .new:
            return [.iphoneXr,.iphoneXs,.iphoneXsMax]
        case .ipad:
            return [.iPadMini,.iPadAir,.iPadPro10_5inch,.iPadPro_11inch,.iPadPro_12_9inch]
        }
        return []
    }
    static public func current()->DeviceSize?{
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .ipad
        }
        let height = UIScreen.main.bounds.height;
        var deviceSizes = DeviceSize.all.filter({$0.devices.map({$0.height}).contains(height)});
        if UIDevice.current.userInterfaceIdiom == .phone && deviceSizes.first != .old{
            return .new
        }
        return deviceSizes.first;
    }
    
}
public enum DeviceType:CGFloat{
 case iPhoneSE_1G
 case iPhoneSE_2G
 case iphone8
 case iphone8Plus
 case iphoneXr
 case iphoneXs
 case iphoneXsMax
 case iphoneProMax
 case iPadMini
 case iPadAir
 case iPadPro10_5inch
 case iPadPro_11inch
 case iPadPro_12_9inch
  static public func lessThanAndEqual(_ heightCheck:Bool=true,_ deviceType:DeviceType)->Bool{
      if heightCheck{
      return UIScreen.main.bounds.height <= deviceType.orientationHeight
    }else{
      return UIScreen.main.bounds.width <= deviceType.orientationWidth
    }
 }
 static public func bigThanAndEqual(_ heightCheck:Bool=true,_ deviceType:DeviceType)->Bool{
     if heightCheck{
  return UIScreen.main.bounds.height >= deviceType.orientationHeight
  }else{
    return UIScreen.main.bounds.width >= deviceType.orientationWidth
  }
 }
 static public func lessThan(_ heightCheck:Bool=true,_ deviceType:DeviceType)->Bool{
     if heightCheck{
    return UIScreen.main.bounds.height < deviceType.orientationHeight
  }else{
    return UIScreen.main.bounds.width < deviceType.orientationWidth
  }
 }
 static public func bigThan(_ heightCheck:Bool=true,_ deviceType:DeviceType)->Bool{
  if heightCheck {
    return UIScreen.main.bounds.height > deviceType.orientationHeight
  }else{
    return UIScreen.main.bounds.width > deviceType.orientationWidth
  }
 }
 static public func equal(_ heightCheck:Bool=true,_ deviceType:DeviceType)->Bool{
  if heightCheck{
    return UIScreen.main.bounds.height == deviceType.orientationHeight
  }else{
    return UIScreen.main.bounds.width == deviceType.orientationWidth
  }
 }
private var orientationHeight:CGFloat{
    if UIDevice.current.orientation.isLandscape{
        return self.width
    }
    return height
}
private var orientationWidth:CGFloat{
    if UIDevice.current.orientation.isLandscape{
        return self.height
    }
    return width
}
public var height:CGFloat{
  switch self{
  case .iPhoneSE_1G:
    return 568.0
  case .iPhoneSE_2G:
    return 667.0
  case .iphone8:
   return 667.0
  case .iphone8Plus:
   return 736.0
  case .iphoneXr:
   return 896.0
  case .iphoneXs:
   return 812.0
  case .iphoneXsMax:
   return 896.0
  case .iphoneProMax:
   return 926.0
  case .iPadMini:
   return 1024.0
  case .iPadAir:
   return 1024.0
  case .iPadPro10_5inch:
   return 1112.0
  case .iPadPro_11inch:
   return 1194.0
  case .iPadPro_12_9inch:
   return 1366.0
  }
 }
  public var width:CGFloat{
    switch self{
    case .iPhoneSE_1G:
     return 320.0
    case .iPhoneSE_2G:
    return 375.0
    case .iphone8:
     return 375.0
    case .iphone8Plus,.iphoneXr:
     return 414.0
    case .iphoneXs:
     return 375.0
    case .iphoneXsMax:
     return 314.0
    case .iphoneProMax:
     return 428
    case .iPadMini,.iPadAir:
     return 768.0
    case .iPadPro10_5inch,.iPadPro_11inch:
     return 834.0
    case .iPadPro_12_9inch:
     return 1024.0
    }
   }
}
public var bs_hasTopNotch: Bool {
    var edge:UIEdgeInsets?
   if #available(iOS 13.0,  *) {
    edge = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets
   }else{
    edge = UIApplication.shared.delegate?.window??.safeAreaInsets
   }
    if UIDevice.current.orientation.isLandscape {
        return (edge?.left ?? 0) > 20 ||  (edge?.right ?? 0) > 20
    }else{
        return   (edge?.top ?? 0) > 20
    }
}
public var bs_safeArea: UIEdgeInsets? {
    var edge:UIEdgeInsets?
   if #available(iOS 13.0,  *) {
    edge = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets
   }else{
    edge = UIApplication.shared.delegate?.window??.safeAreaInsets
   }
    return edge;
}
public extension UIScreen{
    public var screenHeightWithoutSafeArea:CGFloat{
        let  safeArea = bs_safeArea
        return UIScreen.main.bounds.height-(safeArea?.top ?? 0)-(bs_safeArea?.bottom ?? 0)
    }
    public var screenWidthWithoutSafeArea:CGFloat{
        let  safeArea = bs_safeArea
        return UIScreen.main.bounds.width-(safeArea?.left ?? 0)-(bs_safeArea?.right ?? 0)
    }
    public var screenHeightWithoutTopSafeArea:CGFloat{
        let  safeArea = bs_safeArea
        return UIScreen.main.bounds.height-(safeArea?.top ?? 0)
    }
    public var screenHeightWithoutBottomSafeArea:CGFloat{
        let  safeArea = bs_safeArea
        return UIScreen.main.bounds.height-(safeArea?.bottom ?? 0)
    }
}
#endif

 extension Array{
     //index will be removed for example if index = 5 from index 0 t0 5 will removed
     @discardableResult public mutating func bs_removeTo(index:Int)->Bool{
         return self.bs_removeFrom(0, toIndex: index);
        }
     mutating public func bs_removeFrom(_ index:Int,toIndex:Int)->Bool{
         if self.indices.contains(index) && self.indices.contains(toIndex){
         self.removeSubrange(index ... toIndex)
             return true;
         }
         return false;
     }
      public func bs_isContainObject(classType:AnyClass)->AnyObject?{
        for object in self {
            if  ((object as? AnyObject)?.isKind(of:classType))!
            {
                return object as AnyObject?;
                break;
            }
        }
        return nil;
    }
     public func bs_index(_ indexs:[Int])->[Any]
    {
        var objects:Array = Array.init();
        for var index:Int in indexs
        {
            objects.append(self[index]);
        }
        return objects;
    }
     public var bs_second:Any?{
        if self.count >= 2 {
            return self[1] as? Any;
        }
      return nil
    }
     public var bs_thired:Any?{
        if self.count >= 3 {
            return self[2] as? Any;
        }
      return nil
    }
     public var bs_beforeLast:Any?{
        if self.count >= 2 {
            return self[self.count-2] as? Any;
        }
      return nil
    }
     public func bs_indexOfObject(object : AnyObject) -> NSInteger {
         return (self as NSArray).index(of: object)
     }
     mutating func bs_removeObject<T>(obj: T) where T : Equatable {
         self = self.filter({$0 as? T != obj})
     }
}
/*    **Dictionary**   */

 extension Dictionary where Key: ExpressibleByStringLiteral{
    public func bs_getStringValueWithNewLine()->String
    {
        
        var temp:String=""
        for (_, value) in self {
            temp = "\(temp) \n \(value)" ;
        }
        
        return temp;
    }
    
    public func bs_allValues()->Array<Any>{
        return Array(self.values.map{ $0 });
    }
    
}
 extension Dictionary where Value: Equatable {
    public func bs_KeyForValue(_ val: Value) -> Key? {
        return first(where: { $1 == val })?.0
    }
  
}

/*    **String**   */

public extension String{
//    enum Side{
//        case first
//        case last
//    }
//
//    func bs_removeChar(itemNumber:Int,side : Side) -> String{
//        var  item = self
//        switch side{
//        case .first:
//            for i in 0..<itemNumber{
//                item.removeFirst()
//            }
//            return item
//        case .last:
//            for i in 0..<itemNumber{
//                item.removeLast()
//            }
//            return item
//        }
//    }
    public var bs_fileURL:URL{
        return URL.init(fileURLWithPath: self);
    }
    public var isEmpty:Bool{
        return (RegularExpression.empty.matches(self))
    }
    public var bs_remoteURL:URL?{
        return URL.init(string:self)
    }
    public var  bs_containsLetters:Bool{
        if self.rangeOfCharacter(from:CharacterSet.letters) != nil{
         return true
        }
        return false;
    }
    public func bs_index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    public func bs_substring(from: Int) -> String {
        let fromIndex = bs_index(from: from)
        return substring(from: fromIndex)
    }
    
    public func bs_substring(to: Int) -> String {
        let toIndex = bs_index(from: to)
        return substring(to: toIndex)
    }
    
    public func bs_substring(with r: Range<Int>) -> String {
        let startIndex = bs_index(from: r.lowerBound)
        let endIndex = bs_index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
       public var bs_int32:Int32?{
            return Int32.init(self)
        }
    public var bs_int16:Int16?{
            return Int16.init(self);
        }
    public var bs_int8:Int8?
        {
      return Int8.init(self)
        }
    public var bs_int64:Int64?{
        return Int64.init(self)
        }
    
    public var bs_fullrange: NSRange {
        return NSRange(location: 0, length: count)
    }
    public func bs_ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    public static func bs_contentsOf(_ stringUrl:String)->String?{
         let url:URL = URL.init(fileURLWithPath:stringUrl)
        return try? String.init(contentsOf: url);
    }
    public var bs_float:Float?{
        return Float(self);
    }
    #if os(iOS)
    public var respectLanguage:String{
    if UIView.userInterfaceLayoutDirection(for:UIApplication.shared.bs_rootViewController!.view.semanticContentAttribute) == .rightToLeft {
        return String(self.reversed());
        }else{
            return self;
        }
    }
    #endif
    public var bs_worlds:[String]{
        let wordList =  self.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}
        return wordList;
    }
    public var bs_worldsCount:Int{
        return self.bs_worlds.count;
    }

    public var bs_removeSpaces : String{
        return self.replacingOccurrences(of: " ", with: "");
    }

    public static func  bs_groupingSeparator (value:Int,seprator:String) -> String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = seprator
        let formattedNumber = numberFormatter.string(from: NSNumber(value:value))
        return formattedNumber
    }
    
    public static func bs_duration(_ totalSeconds:Double)->String{
        let h : Int = Int(totalSeconds / 3600)
        let m : Int = Int((totalSeconds - Double(h) * 3600) / 60)
        let s : Int = Int(totalSeconds - 3600 * Double(h)) - m * 60
        if h != 0 {
        return String(format: "%02d:%02d:%02d", h, m, s)
        }else{
        return String(format: "%02d:%02d", m, s)
        }
    }

    public func bs_htmlText(fontName:String,fontSize:String,alignment:String) -> String{
        //<font face='\(fontName)'>
        return "<!DOCTYPE html><html><head><title></title> <style> body{ font-family:\"\(fontName)\";font-size:\(fontSize)px;}</style> </head> <body align=\"\(alignment)\">\(self) </body> </html>";
    }
    #if os(iOS)
    public func bs_htmlTextWithRespectLanguage(fontName:String,fontSize:String) -> String{
        var alignment = "";
        if #available(iOS 9.0, *) {
            if UIView.userInterfaceLayoutDirection(
                for:UIView.appearance().semanticContentAttribute) == .rightToLeft {
                alignment = "right"

            }else{
                alignment = "left"

            }
        } else {
            // Use the previous technique
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                alignment = "right"
            }
            else{
                alignment = "left"
            }
        }
        return self.bs_htmlText(fontName:fontName, fontSize: fontSize, alignment:alignment)
    }
    #endif

    public func bs_replace(target: String, withString: String) -> String {
        
        return self.replacingOccurrences(of: target, with:withString, options: .literal, range: nil)
    }
    public func bs_subtract(_ start:Int,_ last:Int)->String{
        let firstIndex = self.index(self.startIndex, offsetBy:start, limitedBy: self.endIndex)!;
        
        let lastIndex = self.index(self.startIndex, offsetBy: last, limitedBy: self.endIndex)!;
        let tempObject =  Range<String.Index>.init(uncheckedBounds: (lower:firstIndex, upper:lastIndex))
        return String(self[tempObject])
    }

    public func bs_arNumberToEn()-> String {
        let numbersDictionary : Dictionary = ["٠" : "0","١" : "1", "٢" : "2", "٣" : "3", "٤" : "4", "٥" : "5", "٦" : "6", "٧" : "7", "٨" : "8", "٩" : "9"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        return str
    }
    
    //    var bs_md5:String {
    //        get{
    //            let messageData = self.data(using:.utf8)!
    //            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    //            _ = digestData.withUnsafeMutableBytes {digestBytes in
    //                messageData.withUnsafeBytes {messageBytes in
    //                    CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
    //                }
    //            }
    //
    //            return digestData.map { String(format: "%02hhx", $0) }.joined()
    //        }
    //    }
    
    public func bs_cgFloat() -> CGFloat? {
        let myFloat:Float = (self as NSString).floatValue
        return CGFloat(myFloat);
    }
    public var bs_int:Int?{
        return Int.init(self);
    }
    public var bs_locationDegree:CLLocationDegrees{
        return  CLLocationDegrees.init(self.bs_cgFloat()!);
    }
    #if os(iOS)
    public func bs_widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    public func bs_heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    public func bs_height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        return actualSize.height
    }
    #endif
    public var bs_html2AttributedString: NSAttributedString? {
        return Data(utf8).bs_html2AttributedString
    }
    public var bs_html2String: String {
        return bs_html2AttributedString?.string ?? ""
    }
    public static func bs_numberClass(numberValue:Int,classNumber:Int)->String{
        var stringFormate="%0\(classNumber)d";
        var value =  String(format:stringFormate,numberValue);
        return value
    }
    public static func bs_secondsToHoursMinutesSeconds(_ seconds:Double) -> (Double, Double, Double) {
        var tempSeconds = seconds;
        let (hr,  minf) = modf (tempSeconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (hr, min, 60 * secf)
    }
     public func bs_appendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    public var localize_:String {
    return NSLocalizedString(self, comment:"")
    }
    public var bs_double:Double?{
        return Double.init(self)
    }
    public func bs_localizedWith(variables: CVarArg...) -> String {
        return String(format: self.localize_, arguments: variables)
    }
    public func bs_localizedd(_ language:String?=nil,tableName:String?=nil,variables: CVarArg...) -> String {
        var value = self.bs_localized(language,tableName);
        return String(format:value, arguments: variables)
    }
    public func bs_localized(_ language:String?=nil,_ tableName:String?=nil) ->String {
        let tempLanguage:String = language  ?? Locale.current.languageCode ?? "Base"
        if let path:String = Bundle.main.path(forResource: tempLanguage, ofType: "lproj") , let bundle:Bundle = Bundle(path: path) {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "", comment: "")
        }else{return ""};
    }
    public func bs_toDic()->[String:String]{
        var  dic:[String:String]=[String:String]();
        for object in self.components(separatedBy:",") {
            let components = object.components(separatedBy:"=")
            if let key:String = components.first ,
                let value:String = components.last{
                dic[key]=value;
                print(value)
            }
        }
        return dic;
    }
    public func bs_matches(pattern: String) -> Bool {
           let regex = try! NSRegularExpression(
               pattern: pattern,
               options: [.caseInsensitive])
           return regex.firstMatch(
               in: self,
               options: [],
               range: NSRange(location: 0, length: utf16.count)) != nil
    }
    #if os(iOS)
    public func bs_isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }

        let urlPattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.bs_matches(pattern: urlPattern)
    }
    #endif
    public func bs_isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    public func bs_stripHTML() -> String {
        var tempString = self;
        tempString = tempString.replacingOccurrences(of: "&ndash;", with: "-")
        tempString = tempString.replacingOccurrences(of: "&nbsp;", with: " ")
        return tempString.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
     public func bs_matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
//    var isValidNumber:Bool{
//        var enteredText = Int(self)
//        if enteredText == nil{
//            return false
//        }
//        else{
//            return true
//        }
//    }
     public var bs_locationDegrees:CLLocationDegrees?{
        let itemString:String = self;
        if let  item:CLLocationDegrees = CLLocationDegrees.init(itemString){
            return item;
        }
        return nil;
    }
     public var bs_nsNumber:NSNumber?{
        if let doubleValue = Double.init(self) {
            return NSNumber(value:doubleValue);
        }
        return nil;
    }
     public var bs_isRemoteFile:Bool{ if self.contains("http"){
        return true
        }
        return false
    }
    func bs_fileName() -> String {
        return URL(fileURLWithPath: self).bs_fileName()
    }

    func bs_fileExtension() -> String {
        return URL(fileURLWithPath: self).bs_fileExtension();
    }
    func bs_writeToDocumentDirectory(_ fileName:String="file",_ fileType:String="json"){
        if var desktopPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            desktopPath.appendPathComponent("\(fileName).\(fileType)")
            do {
                try self.write(to: desktopPath, atomically: false, encoding: .utf8);
            }catch{
                print("error");
            }
        }
    }
    public var bs_isDigit:Bool{
        let formate = NumberFormatter.init();
        let isDecimal = formate.number(from: self) != nil;
        return isDecimal;
    }
    public func bs_slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    ///*////
    public func bs_search(searchedText:String)->Range<String.Index>?{
        if let range = self.range(of:searchedText) {
            return range
        }
        return nil;
    }
    private func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    private func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    private func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    public mutating func bs_prefixClosed( around:String,searchedText:String)->Range<String.Index>?{
        var text = self
        var aroundRange = text.bs_search(searchedText:around);
        let arroundLowerBound = self.distance(from: text.startIndex, to: aroundRange!.lowerBound)

        
        var itemRanges:[Range<String.Index>?]=text.bs_ranges(of:searchedText)
        
        var lastClosedRange:(Range<String.Index>)?=itemRanges.first as! (Range<String.Index>);
        

        for itemRange in itemRanges {
            let lastClosedLowerBound = self.distance(from: text.startIndex, to: lastClosedRange!.lowerBound)
            let itemLowerBound = self.distance(from: text.startIndex, to: itemRange!.lowerBound)
            
                if (arroundLowerBound-itemLowerBound) > lastClosedLowerBound{
                    lastClosedRange = itemRange;
                }
        
        }
        print(self.substring(with: lastClosedRange!));
        let itemLowerBound = self.distance(from: text.startIndex, to: lastClosedRange!.lowerBound)
        print(itemLowerBound);
        return lastClosedRange;

    }
    public mutating func bs_suffixClosed( around:String,searchedText:String)->Range<String.Index>?{
        var text = self
        var aroundRange = text.bs_search(searchedText:around);
        let arroundLowerBound = self.distance(from: text.startIndex, to: aroundRange!.lowerBound)

        
        var itemRanges:[Range<String.Index>]=text.bs_ranges(of:searchedText)
        itemRanges.removeAll { (item) -> Bool in
        let itemLowerBound = self.distance(from: text.startIndex, to: item.lowerBound)
        return itemLowerBound < arroundLowerBound
        }
        
        var lastClosedRange:(Range<String.Index>)?=itemRanges.last as! (Range<String.Index>);
        

        for itemRange in itemRanges.reversed() ?? [] {
            let lastClosedLowerBound = self.distance(from: text.startIndex, to: lastClosedRange!.lowerBound)
            let itemLowerBound = self.distance(from: text.startIndex, to: itemRange.lowerBound)
            
                if  lastClosedLowerBound > (arroundLowerBound-itemLowerBound){
                    lastClosedRange = itemRange;
                }
        
        }
        print(self.substring(with: lastClosedRange!));
        let itemLowerBound = self.distance(from: text.startIndex, to: lastClosedRange!.lowerBound)
        print(itemLowerBound);
        return lastClosedRange;
    }
}

/*    **Int**   */

 extension Int {
   public var bs_int:Int{
        return Int.init(self);
    }
   public var bs_float:Float{
        return  Float.init(self)
    }
   public var bs_cgFloat:CGFloat{
        return  CGFloat.init(self)
    }
   public var bs_double:Double{
        return  Double.init(self)
    }
   public var bs_int8:Int8{
        return  Int8.init(self);
    }
   public var bs_int16:Int16{
        return  Int16.init(self);
    }
   public var bs_int64:Int64{
        return  Int64.init(self);
    }
   public var bs_int32:Int32{
        return  Int32.init(self);
    }
   public var bs_number:NSNumber{
        return  NSNumber.init(value: self);
    }
   public var bs_cmTime:CMTime{
        return  CMTimeMakeWithSeconds(Double(self), preferredTimescale: 1)
    }
   public var bs_inHundred:String{
        return String.bs_numberClass(numberValue: self, classNumber: 2);
    }
   public var bs_inThousands:String{
        return String.bs_numberClass(numberValue: self, classNumber: 3);
    }
    public init(random range: ClosedRange<Int>) {
         let min = range.lowerBound
         let max = range.upperBound
         self = Int(arc4random_uniform(UInt32(1 + max - min))) + min
     }
    public static func bs_evenRandomNumber(range:ClosedRange<Int>)->Int{
         var variable = Int.init(random: range);
         repeat {
             if (variable - 1 >= range.lowerBound) && (variable-1 != 0) {
                 variable = variable - 1
                 return variable
             }else{
                 break
             }
             
         }  while variable.bs_isOdd
         
         variable = self.bs_evenRandomNumber(range: range);
         return variable;
     }
     public var bs_isEven:Bool{
         return self % 2 == 0
     }
     public var bs_isOdd:Bool{
         return self % 2 != 0
     }
    public var bs_string:String{
        return String(self);
    }
}

/*    **Int16**   */

 extension Int16
{
    public var bs_int:Int
    {
        return Int.init(self);
    }
    public var bs_float:Float{
        return  Float.init(self)
    }
    
    public var bs_cgFloat:CGFloat{
        return  CGFloat.init(self)
    }
    
    public var bs_double:Double{
        return  Double.init(self)
    }
    public var bs_int8:Int8{
        return  Int8.init(self);
    }
    public var bs_int32:Int32{
        return  Int32.init(self);
    }
    public var bs_int64:Int64{
        return  Int64.init(self);
    }
    public var bs_locationDegree:CLLocationDegrees{
        return  CLLocationDegrees.init(self);
    }
    public var bs_string:String {
        return "\(self)"
    }
}

/*    **Int32**   */

public extension Int32{
    public var bs_int:Int{
        return Int.init(self);
    }
    public var bs_float:Float{
        return  Float.init(self)
    }
    public var bs_cgFloat:CGFloat{
        return  CGFloat.init(self)
    }
    public var bs_double:Double{
        return  Double.init(self)
    }
    public var bs_int8:Int8{
        return  Int8.init(self);
    }
    public var bs_int16:Int16{
        return  Int16.init(self);
    }
    public var bs_int64:Int64{
        return  Int64.init(self);
    }
    public var bs_locationDegree:CLLocationDegrees{
        return  CLLocationDegrees.init(self);
    }
    public var bs_string:String {
        return "\(self)"
    }
}

/*    **Int64**   */

 extension Int64 {
    public var bs_int:Int
    {
        return Int.init(self);
    }
    public var bs_float:Float{
        return  Float.init(self)
    }
    
    public var bs_cgFloat:CGFloat{
        return  CGFloat.init(self)
    }
    
    public var bs_double:Double{
        return  Double.init(self)
    }
    public var bs_int8:Int8{
        return  Int8.init(self);
    }
    public var bs_int16:Int16{
        return  Int16.init(self);
    }
    public var bs_int32:Int32{
        return  Int32.init(self);
    }
    public var bs_number:NSNumber{
        return  NSNumber.init(value: self);
    }
    public var bs_string:String {
        return "\(self)"
    }
}

/*    **CGFloat**   */

 extension CGFloat
{
    public var bs_float:Float?{
        return Float.init(self);
    }
    public func bs_int() ->Int{
        return Int(self)
    }
    public var bs_locationDegree:CLLocationDegrees{
        return  CLLocationDegrees.init(self);
    }
    public func bs_removeDecemal(var classNumber:Int=1)->Double?{
        var stringValue = String(format: "%.0\(classNumber)f", self)
        var doubleValue = Double.init(stringValue);
        return doubleValue;
    }
}

/*    **TimeInterval**   */

 extension TimeInterval {
    
    public func bs_stringFromTimeInterval() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

/*    **NSNumber**   */

 extension NSNumber {
   public static func bs_isNumber(object:Any)->Bool{
        switch object {
        case is CGFloat: return true
        case is Float: return true
        case is Double: return true
        case is Int: return true
        case is UInt: return true
            
        default: return false;
        }
    }
}

/*    **Double**   */

public extension Double{
    public func bs_toStringWith(_ format:String)->String{
        var beginStringValue="0";
        if self.bs_error == false{
            beginStringValue = String.init(format:format,self)
        }
        return beginStringValue;
    }
    public var bs_error:Bool{
         return (self.isNaN || self.isInfinite)
     }
    public var bs_string:String?{
        return String(self);
    }
    public func bs_removeDecemal(var classNumber:Int=1)->Double?{
        var stringValue = String(format: "%.0\(classNumber)f", self)
        var doubleValue = Double.init(stringValue);
        return doubleValue;
    }
    public var bs_int:Int?{
        return Int.init(self);
    }
    public var bs_inHundred:String{
        return String.bs_numberClass(numberValue: self.bs_int ?? 0, classNumber: 2);
    }
    public var bs_inThousands:String{
        return String.bs_numberClass(numberValue: self.bs_int ?? 0, classNumber: 3);
    }
    public func bs_secondsToHoursMinutesSeconds() -> (Double, Double, Double) {
        return String.bs_secondsToHoursMinutesSeconds(self);
    }
    public var bs_locationDegree:CLLocationDegrees{
        return  CLLocationDegrees.init(self);
    }
    public var bs_duration:String {
        return String.bs_duration(self);
    }
    public var bs_cmTime:CMTime {
        return  CMTimeMakeWithSeconds(self, preferredTimescale: 1)
    }
    public var bs_cgFloat:CGFloat?{
        return CGFloat(self);
    }
    public var bs_float:Float{
        return Float.init(self);
    }
}

/*    **Float**   */

 extension Float{
     public static func bs_lessNumberAbleToDivideIt(upper:Float,lower:Float)->Float{
             var value = upper;
             var reminder:Float=0
            if upper.remainder(dividingBy:lower) != 0{
            repeat {
                 reminder = upper.remainder(dividingBy:lower)
                 if  reminder == 0 {
                     break;
                 }else{
                     value = value-1
                     //All non-integer values go here
                 }
                 
             }while (value > 0) && (reminder == 0)
             return value;
            }else{
             return upper;
            }
    }
     public var bs_locationDegree:CLLocationDegrees{
        return  CLLocationDegrees.init(self);
    }
     public var bs_cmTime:CMTime {
        return  CMTimeMakeWithSeconds(Double(self), preferredTimescale: 1)
    }
     public var bs_double:Double {
        return Double(self)
    }
     public var bs_int:Int {
        return Int.init(self);
    }
     public static func  bs_isMultiple(number:Float,multiplicityValue:Float)->Bool{
        if number == 0 || multiplicityValue == 0 {
            return false;
        }
        if number.remainder(dividingBy: multiplicityValue) == 0 {
            return true;
        }
        return false;
    }
    public func bs_isItMultipleOf(multiplicityValue:Float)->Bool{
        return Float.bs_isMultiple(number:self,multiplicityValue:multiplicityValue);
    }
    public var bs_cgFloat:CGFloat?{
        return CGFloat(self);
    }
    public var bs_duration:String {
        return String.bs_duration(Double.init(self));
    }
}
/*    **Array**   */

 extension Array where Element == String {
     public func bs_withSeperator(seperator:String) -> String{
        var tempText = "";
        for object in self {
            tempText = tempText+object+seperator;
        }
        if tempText.count > 1 {
            tempText.removeLast();
        }
        return tempText;
    }
}

 extension Array where Element == Int {
    public func bs_bigestValue() -> Int?{
        var bigestValue:Int?
        for item in self{
            if let tempValue:Int = bigestValue,tempValue > item{
                bigestValue = tempValue
            }else{
                bigestValue = item;
            }
        }
        return bigestValue;
    }
    public func bs_lowestValue() -> Int?{
        var bigestValue:Int?
        for item in self{
            if let tempValue:Int = bigestValue,tempValue < item{
                bigestValue = tempValue
            }else{
                bigestValue = item;
            }
        }
        return bigestValue;
    }
    public func bs_sum() -> Int{
        var total = 0;
        for object in self {
            total = total+object;
        }
  
        return total;
    }
}

extension Array where Element == Double {
   public func bs_sum() -> Double{
    var total:Double = 0;
       for object in self {
           total = total+object;
       }
       return total;
   }
}

/*    **Array**   */

public extension Array where Element: Equatable {
    public func bs_subtracting(_ array: Array<Element>) -> Array<Element> {
        self.filter { !array.contains($0) }
    }

    public func bs_filterDuplicates(includeElement: (_ lhs:Element,_ rhs:Element) -> Bool) -> [Element]{
            var results = [Element]()

            forEach { (element) in
                let existingElements = results.filter {
                    return includeElement(element,$0)
                }
                if existingElements.count == 0 {
                    results.append(element)
                }
            }

            return results
    }
}
public extension Bundle {
    static var bs_releaseVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    static var bs_buildVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}

public extension Array where Element == Dictionary<String, AnyObject> {
    func bs_json()->String?{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            return theJSONText;
        }
        return nil;
    }
}
public extension Array where Element == Dictionary<String, Any> {
    func bs_json()->String?{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .utf8)
            return theJSONText;
        }
        return nil;
    }
}

/*    **NSObject**   */

public extension NSObject{
  func bs_AudioServicesPlaySystemSound(fileName:String,fileType:String)->SystemSoundID? {
        var soundID: SystemSoundID = 0
        if  let filePath:String = Bundle.main.path(forResource: fileName, ofType:fileType){
            let url:NSURL = NSURL(fileURLWithPath: filePath)
            AudioServicesCreateSystemSoundID(url, &soundID)
            AudioToolbox.AudioServicesPlaySystemSound(soundID)
        }else{
        print("AudioServicesPlaySystemSound can't play")}
        
        return soundID;
    }
 var bs_NSNumber:NSNumber?{
        if let item:NSNumber = self as? NSNumber{
            return item;
        }
        return nil;
    }
  var bs_Int:Int?{
        if let item:Int = self.bs_NSNumber?.intValue{
            return item;
        }
        return nil;
    }
  var bs_Double:Double?{
        if let item:Double = self.bs_NSNumber?.doubleValue{
            return item;
        }
        return nil;
    }
  var bs_Float:Float?{
        if let item:Float = self.bs_NSNumber?.floatValue{
            return item;
        }
        return nil;
    }
  var bs_String:String?{
        if let item:String = self as? String{
            return item;
        }
        return nil;
    }
}

/*    **Dictionary**   */

public extension Dictionary {
    mutating func bs_merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    static func bs_initDicFromJson(text: String) -> [String:String]? {
        if let data:Data = text.data(using: String.Encoding.utf8) {
            do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:String]
            return json
            } catch{
                return nil;
            }
        }
        return nil
    }
    
    func bs_json()->String?{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding:.utf8)
            return theJSONText;
        }
        return nil;
    }
}

public protocol Copying {
    init(original: Self)
}

public extension Copying {
   public func copy() -> Self {
        return Self.init(original: self)
    }
}
public extension Collection {
    func bs_replaceFirst(_ newElement:Self.Element?,whereIs:(Self.Element) throws -> Bool) -> [Self.Element]?{
        if var newArray:[Self.Element] = self as? [Self.Element]{
            let index = try? newArray.firstIndex(where:whereIs)
        if let newElement:Iterator.Element = newElement, let index:Int = index{
                newArray[index] = newElement
            }
        }
        return nil;
        }
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
    func bs_replaceElement(_ item:Iterator.Element?,items:[Iterator.Element],whereIsEqual:(Iterator.Element,Iterator.Element)-> Bool)->[Iterator.Element]{
        let selfArray:[Iterator.Element] = self as? [Iterator.Element] ?? []
        if let item:Iterator.Element = item{
        let newItems = selfArray.flatMap({whereIsEqual($0,item) ? items:[$0]})
        return newItems
        }else{
        return selfArray
        }
    }
}
public extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
public extension Array{
    func bs_enumeratedTowObject(_ handler:((Iterator.Element?,Iterator.Element?)->Void)?){
        var lastIndex:Int = -1;
        for index in 0...((self.count/2)-1){
            lastIndex=lastIndex+1
            let firstPage = self.bs_getOptional(lastIndex)
            lastIndex=lastIndex+1
            let secondPage = self.bs_getOptional(lastIndex)
            handler?(firstPage,secondPage);
        }
    }
}
/*    **MKMapItem**   */

 extension MKMapItem
{
      public convenience init(latitude:Double,longitude:Double) {
        let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        self.init(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
    }
}

/*    **UIImage**   */
 #if os(iOS)
 public extension UIImage {
        public func bs_pixelColor(atLocation point: CGPoint) -> UIColor? {
             guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else { return nil }

             let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

             let bytesPerPixel = cgImage.bitsPerPixel / 8

             let pixelInfo: Int = ((cgImage.bytesPerRow * Int(point.y)) + (Int(point.x) * bytesPerPixel))

             let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
             let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
             let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
             let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

             return UIColor(red: r, green: g, blue: b, alpha: a)
         }
    public var bs_isLight: Bool {
        self.cgImage?.bs_isLight ?? false
    }
    public enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    public func bs_jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    //
    
    public func bs_getSizeIn(_ type: Data.DataUnits)-> (Double?,String?) {
        guard let data = self.pngData() else {
            return (nil,nil)
        }
        return data.bs_getSizeIn(type)
    }
    public static func bs_initate(cotnent:String)->UIImage?{
        var image:UIImage? = UIImage.init(named:"\(cotnent).png");
        if image == nil {image = UIImage.init(named:"\(cotnent).jpg")}
        if image == nil {image = UIImage.init(named:"\(cotnent).jpeg")}
        return image;
    }
    public func bs_flippedImage() -> UIImage {
        let image = self.withHorizontallyFlippedOrientation();
        return image
    }
     class public func bs_aspectFitSize(imageSize:CGSize,frameSize:CGSize)->CGSize{
     var aspect = ((imageSize.width) / (imageSize.height))
     if ((frameSize.width / aspect) <= frameSize.height)
       {
         return CGSize.init(width: frameSize.width, height: frameSize.width/aspect)
       } else {
         return CGSize.init(width: frameSize.height * aspect, height:frameSize.height)
       }
  }
    public func bs_resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    public func bs_resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    public class func bs_ratioSize(viewWidth:CGFloat,image:UIImage)->CGSize{
            let myImageWidth = image.size.width
            let myImageHeight = image.size.height
            let myViewWidth = viewWidth
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            return CGSize(width: myViewWidth, height: scaledHeight)
        
    }
    public class func bs_ratioSize(viewWidth:CGFloat,imageWidth:CGFloat,imageHeight:CGFloat)->CGSize{
        let myImageWidth = imageWidth
        let myImageHeight = imageHeight
        let myViewWidth = viewWidth
        let ratio = myViewWidth/myImageWidth
        let scaledHeight = myImageHeight * ratio
        return CGSize(width: myViewWidth, height: scaledHeight)
        
    }
     static let iphone8:CGFloat=375/667;
     static let iphone8plus:CGFloat=414/736;
     static let iphoneXR:CGFloat=414/896;
     static let iphoneXs:CGFloat=375/812;
     static let iphoneXsMax:CGFloat=414/896;
     static let ipadMini:CGFloat=768/1024;
     static let ipadAir:CGFloat=768/1024;
     static let ipadPro:CGFloat=834/1112;

    public static func bs_requeireBackgroundRation()->CGSize{
        let deviceRatio = UIScreen.main.bounds.size.width/UIScreen.main.bounds.size.height
        if deviceRatio == iphone8 || deviceRatio == iphone8plus{
        return CGSize.init(width: 9, height: 16)
        }else
       if deviceRatio == iphoneXR || deviceRatio == iphoneXs || deviceRatio == iphoneXsMax{
        return CGSize.init(width: 9, height: 19.5)
       }else
       if deviceRatio == ipadMini || deviceRatio == ipadAir  || deviceRatio == ipadPro{
        return CGSize.init(width: 3, height: 4)
       }else if  UIDevice.current.userInterfaceIdiom == .pad{
        return CGSize.init(width: 3, height: 4)
       }else if  UIDevice.current.userInterfaceIdiom == .phone{
        return CGSize.init(width: 9, height:16)
    }
        return CGSize.zero;
    }
    public func bs_isNeedToCropToBeBackgroundImage()->Bool{
      let imageWidth=self.size.width
      let imageHeight=self.size.height
      let imageRation = imageWidth/imageHeight;
        let deviceRatio = UIScreen.main.bounds.size.width/UIScreen.main.bounds.size.height
        if (imageRation == UIImage.iphone8)||(imageRation == UIImage.iphone8plus)||(imageRation == UIImage.iphoneXR)||(imageRation == UIImage.iphoneXs)||(imageRation == UIImage.iphoneXsMax)||(imageRation == UIImage.ipadMini)||(imageRation == UIImage.ipadAir)||(imageRation == UIImage.ipadPro)&&imageRation == deviceRatio{
            return false;
        }
        return true
     }
    public func bs_fixOrientation() -> UIImage? {
    if (self.imageOrientation == UIImage.Orientation.up) {
          return self;
    }
      UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
      let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)

        let normalizedImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext();
      return normalizedImage;
    }
}

/*    **UIImageView**   */
 extension UIImageView{
public func bs_aspectFitSize()->CGSize{
        return UIImage.bs_aspectFitSize(imageSize:self.image?.size ?? CGSize.zero, frameSize: self.frame.size)
     }
    public func bs_calculateImageViewRecInAspectFit()->CGRect{
        let aspictRationSize = bs_aspectFitSize();
        // to get top space
        let x = ((self.frame.size.width-aspictRationSize.width)/2);
        let y = ((self.frame.size.height-aspictRationSize.height)/2);
        
        return CGRect.init(origin: CGPoint.init(x:x, y:y), size:aspictRationSize);
    }
    
    public func bs_renderMode(_ renderingMode:UIImage.RenderingMode){
        let image: UIImage? = self.image?.withRenderingMode(renderingMode)
        self.image = image;
    }

    public func bs_flipImage(){
        
        self.image = self.image?.imageFlippedForRightToLeftLayoutDirection();
    }
    public func bs_flipImageViewWhenLang(direction:NSLocale.LanguageDirection){
        
        let langDirection:NSLocale.LanguageDirection = NSLocale.characterDirection(forLanguage:NSLocale.autoupdatingCurrent.languageCode!)
        
        if langDirection == direction {
            self.image=self.image?.imageFlippedForRightToLeftLayoutDirection()
        }
        
    }
    public func bs_imageRespectLanguage(){
        if (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft){
            self.bs_flipImage();
        }
    }
    public func bs_loadGifImage(url:URL,successHandler:((Data)->Void)?,errorHandler:((Error?)->Void)?){
        let fileName = url.lastPathComponent;
        var docURL = FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last as? NSURL
        let diskPath = docURL?.appendingPathComponent(fileName)

        var localData:Data? = try? Data.init(contentsOf: diskPath!)
        if localData == nil {
            URLSession.shared.dataTask(with: url) { (data:Data?, urlResponse:URLResponse?,error:Error?) in
                if data != nil {
                    do {
                    try data!.write(to:diskPath!, options: [.atomicWrite])
                    } catch{
                        print(error);
                        print(error);

                    }
                    DispatchQueue.main.async {
                        successHandler?(data!)
                    }
                }else{
                    DispatchQueue.main.async {
                   errorHandler?(error)
                    }
                }
                }.resume();
        }else{
            successHandler?(localData!);
        }
    }
    public func bs_loadGifImage(url:URL?,imageHandler: ((Data)->Void)?, placeHolderHandler:(()->Void)?){
        placeHolderHandler?();
        if url != nil {
        self.bs_loadGifImage(url: url!, successHandler: { (data:Data) in
            imageHandler?(data);
        }, errorHandler: { (error:Error?) in
            placeHolderHandler?();
        })
    }
   }
    public var bs_ratioSize: CGSize {
       if let myImage = self.image {
           let myImageWidth = myImage.size.width
           let myImageHeight = myImage.size.height
           let myViewWidth = self.frame.size.width
           let ratio = myViewWidth/myImageWidth
           let scaledHeight = myImageHeight * ratio
           return CGSize(width: myViewWidth, height: scaledHeight)
       }
       return CGSize(width: -1.0, height: -1.0)
   }
 }

/*    **UITextField**   */

@IBDesignable
 extension UITextField {
     public func bs_shouldChangeCharactersIn(_ charactersCount:Int,range:NSRange,replacementString:String)->Bool{
         let currentCharacterCount = self.text?.count ?? 0
         if range.length + range.location > currentCharacterCount {
           return false
         }
         let newLength = currentCharacterCount + replacementString.count - range.length
         return newLength <= charactersCount
       }
    
//    @IBInspectable var bs_paddingLeft: CGFloat {
//        get {
//            return leftView!.frame.size.width
//        }
//        set {
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
//            leftView = paddingView
//            leftViewMode = .always
//        }
//    }
//    @IBInspectable var bs_paddingRight: CGFloat {
//        get {
//            return rightView!.frame.size.width
//        }
//        set {
//            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
//            rightView = paddingView
//            rightViewMode = .always
//        }
//    }
public func bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds:Float,miniFontRange:Float,maxFontRange:Float,fontSubtractionValue:Float){
    var newFont = UIFont.bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds: subtractFontValueEveryWorlds, numberOfWorlds: self.text!.bs_worldsCount.bs_float, currentFont: self.font!, miniFontRange: miniFontRange, maxFontRange: maxFontRange, fontSubtractionValue: fontSubtractionValue, lastCharacter:self.text?.last ?? " ")
    if newFont != nil {
        self.font = newFont!;
    }
}
}
/*    **UIButton**   */

 extension UIButton{
   public func bs_renderModeForImage(_ renderingMode:UIImage.RenderingMode,_ controlState:UIControl.State){
        let image = self.image(for: controlState)
        let renderImage: UIImage? = image?.withRenderingMode(renderingMode)
        self.setImage(renderImage, for: controlState);
    }
   public func bs_renderModeForBackgroundImage(_ renderingMode:UIImage.RenderingMode,_ controlState:UIControl.State){
        let image = self.backgroundImage(for: controlState);
        let renderImage: UIImage? = image?.withRenderingMode(renderingMode)
        self.setImage(renderImage, for: controlState);
        self.setBackgroundImage(renderImage, for: controlState)
    }
   public func bs_flipImageView(state:UIControl.State){
        self.setImage(self.imageView?.image?.imageFlippedForRightToLeftLayoutDirection(), for: state);
    }
   public func bs_flipImageViewWhenLang(direction:NSLocale.LanguageDirection,state:UIControl.State){
        let langDirection:NSLocale.LanguageDirection = NSLocale.characterDirection(forLanguage:NSLocale.autoupdatingCurrent.languageCode!)
        if langDirection == direction {
            self.setImage(self.imageView?.image?.imageFlippedForRightToLeftLayoutDirection(), for: state);
        }
    }

   public func bs_UnderlineTextButton(title: String?, forState state: UIControl.State)
        {
            self.setTitle(title, for: .normal)
            self.setAttributedTitle(self.attributedString(), for: .normal)
        }

    private func attributedString() -> NSAttributedString? {
            let attributes = [
                NSAttributedString.Key.font :self.titleLabel?.font,
                NSAttributedString.Key.foregroundColor : self.titleColor(for: .normal),
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
                ] as [NSAttributedString.Key : Any]
            let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
            return attributedString
    }
   public func bs_respectLanguageImage(_ controlState:UIControl.State){
        if (UIView.userInterfaceLayoutDirection(
            for: UIView.appearance().semanticContentAttribute) == .rightToLeft)  {
            self.setImage(self.image(for: controlState)!.bs_flippedImage(), for: controlState);
        }
    }
   public func bs_respectLanguage(){
        if ( (UIView.userInterfaceLayoutDirection(
            for: UIView.appearance().semanticContentAttribute) == .rightToLeft) &&
            ( self.titleEdgeInsets.right > 0 || self.titleEdgeInsets.left > 0 ||
                self.imageEdgeInsets.right > 0 || self.imageEdgeInsets.left > 0 ||
                self.contentEdgeInsets.right > 0 || self.contentEdgeInsets.left > 0))
        {
            self.titleEdgeInsets.right =  self.titleEdgeInsets.right * -1;
            self.titleEdgeInsets.left =  self.titleEdgeInsets.left  * -1;
            
            self.imageEdgeInsets.right =  self.imageEdgeInsets.right * -1;
            self.imageEdgeInsets.left =  self.imageEdgeInsets.left * -1;
            
            self.contentEdgeInsets.right =  self.contentEdgeInsets.right * -1;
            self.contentEdgeInsets.left =  self.contentEdgeInsets.left * -1;
            
        }
    }
}

/*    **UIFont**   */

 extension UIFont
{
  public class func bs_printFontFamilyNames(){
      debugPrint("---UIFont---\n")
        UIFont.familyNames.sorted().forEach({ (familyName) in
            debugPrint(UIFont.fontNames(forFamilyName: familyName))
        })
      debugPrint("---UIFont---\n")
    }

   public static func bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds:Float,numberOfWorlds:Float,currentFont:UIFont,miniFontRange:Float,maxFontRange:Float,fontSubtractionValue:Float,lastCharacter:Character)->UIFont?{
                        if numberOfWorlds >= subtractFontValueEveryWorlds {
                            let currentFontSize:Float = currentFont.pointSize.bs_float ?? 0;
        
                            if  numberOfWorlds.bs_isItMultipleOf(multiplicityValue: subtractFontValueEveryWorlds) &&
                                (currentFontSize > miniFontRange) &&
                                (currentFontSize <= maxFontRange) &&
                                ((currentFontSize-fontSubtractionValue) > miniFontRange &&
                                lastCharacter != " ") {
                                let newFontSize = (currentFontSize-fontSubtractionValue);
                                return currentFont.withSize(CGFloat(newFontSize))
                        }
        
        
                        }else{
                            return currentFont.withSize(CGFloat(maxFontRange));
                        }
        return nil
    }

}
///

/*    **UITableView**   */

 extension UITableView
{
   public func bs_registerNib(NibName: String) {
        self.register(UINib(nibName: NibName, bundle: nil), forCellReuseIdentifier: NibName)
    }
    
   public func bs_reloadRows(indexPaths:[IndexPath])
    {
        self.performBatchUpdates({
            self.reloadRows(at: indexPaths, with: UITableView.RowAnimation.none);
        }, completion: nil);
    }
    
   public func bs_deleteRows(indexPaths:[IndexPath])
    {
        self.performBatchUpdates({
        self.deleteRows(at: indexPaths, with:UITableView.RowAnimation.none);
        }, completion: nil);
    }
   public func bs_deleteRow(indexPath:IndexPath){
        self.performBatchUpdates({
        self.deleteRows(at:[indexPath], with: UITableView.RowAnimation.none);
        }, completion: nil);
    }
   public func bs_reloadRow(index:Int)
    {
        self.performBatchUpdates({
            self.reloadRows(at:[IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.none);
        }, completion: nil);
    }

   public func bs_reCaluclateHeaderViewHeight(){
        if let headerView = self.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                self.tableHeaderView = headerView
            }
        }
    }
    public func bs_reCaluclateFooterViewHeight(){
        if let footerView = self.tableFooterView {
             let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
             var footerFrame = footerView.frame
             //Comparison necessary to avoid infinite loop
             if height != footerFrame.size.height {
                footerFrame.size.height = height
                footerView.frame = footerFrame
                 self.tableHeaderView = footerView
             }
         }
     }
    public func bs_register(_ identifier:String,_ bundle:Bundle?=nil){
        self.register(UINib.init(nibName:identifier, bundle: bundle), forCellReuseIdentifier:identifier)
    }
}

/*    **UIViewController**   */

 extension UIViewController {
     public func bs_openBySafari(_ url:URL?){
          if let url:URL = url{
          let vc = SFSafariViewController.init(url:url)
          self.present(vc, animated: true);
          }
      }
    public var screenHeightWithoutSafeAreaWithoutNavigationHeight:CGFloat{
        let  safeArea = bs_safeArea
        return UIScreen.main.bounds.height-(safeArea?.top ?? 0)-(bs_safeArea?.bottom ?? 0)-self.bs_topbarHeight
    }
    public var bs_topbarHeight: CGFloat {
        var heightOfStatusBar:CGFloat=0.0;
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            heightOfStatusBar = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            heightOfStatusBar = UIApplication.shared.statusBarFrame.height
        }
      return heightOfStatusBar +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
  
    public func bs_share(_ sender:UIView?,_ items:[Any],_ completionWithItemsHandler:UIActivityViewController.CompletionWithItemsHandler?){
        // text to share
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceRect = sender?.frame ?? CGRect.zero
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = completionWithItemsHandler;
    }
    public func bs_share(_ sender:UIView?,image:UIImage?,text:String?,_ completionWithItemsHandler:UIActivityViewController.CompletionWithItemsHandler?){
        var items = [Any]();
        if let image:UIImage=image{
        items.append(image)
        }
        if let text:String=text{
        items.append(text)
        }
        self.bs_share(sender,items,completionWithItemsHandler);
    }
   public func bs_presentRightToLeft(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
   public func bs_dismissRightToLeft() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }

    @IBAction public func bs_popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: false);
    }
    
     @IBAction public func bs_popViewControllerAnimated(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
     @IBAction public func bs_dismissViewController(_ sender: Any) {
        self.dismiss(animated: false, completion: nil);
        
    }
    @IBAction public func bs_dismissViewControllerAnimated(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
  
   public func bs_presentPopUp(_ view:UIView,_ direction:UIPopoverArrowDirection? = nil,_ size:CGSize) {
        self.modalPresentationStyle = UIModalPresentationStyle.popover
        // set up the popover presentation controller
        self.popoverPresentationController?.permittedArrowDirections =  direction ?? UIPopoverArrowDirection.up
        self.popoverPresentationController?.delegate = self as! UIPopoverPresentationControllerDelegate
        self.popoverPresentationController?.sourceView = view  // button
        self.popoverPresentationController?.sourceRect = view.bounds
        self.preferredContentSize = size
        UIApplication.shared.bs_rootViewController?.present(self, animated: true, completion: nil);
    }
    public static func bs_generalPush(_ storyboard:UIStoryboard?=UIStoryboard.bs_main,_ navigationController:UINavigationController?=nil){
        let name:String = String(describing: self)
        if  let vc:UIViewController = storyboard?.instantiateViewController(withIdentifier:name) as? UIViewController{
        (navigationController ?? UIApplication.shared.bs_rootNavigationController)?.pushViewController(vc, animated: true);
        }
    }
  
}

/*    **UIView**   */

 extension UIView{
         var bs_parent: UIViewController? {
             // Starts from next (As we know self is not a UIViewController).
             var parentResponder: UIResponder? = self.next
             while parentResponder != nil {
                 if let viewController = parentResponder as? UIViewController {
                     return viewController
                 }
                 parentResponder = parentResponder?.next
             }
             return nil
         }
     public var bs_cornnerRaduisAspectRatio: CGFloat {
        set{
            self.layer.cornerRadius = (self.frame.height/2)*newValue
        }
        get{return -1;}
    }
    public var bs_screenShot:UIImage?{
        return self.bs_screenShot(self.bounds.size);
    }
     public func bs_screenShot(_ size:CGSize)->UIImage?{
        // Begin context
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    public func bs_rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
    public func bs_roundCorners(_ corners: UIRectCorner,_ radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
   
    public func bs_roundCornersRespectLanauge(_ corners: UIRectCorner,_ radius: CGFloat) {
        var internalCorners=corners
        if UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        }else{
            if internalCorners.contains(.topRight){
                internalCorners.remove(.topRight)
                internalCorners.insert(.topLeft)
            }
            if internalCorners.contains(.topLeft){
            internalCorners.remove(.topLeft)
            internalCorners.insert(.topRight)
            }
            if  internalCorners.contains(.bottomRight){
                internalCorners.remove(.bottomRight)
                internalCorners.insert(.bottomLeft)
            }
            if  internalCorners.contains(.bottomLeft){
                internalCorners.remove(.bottomLeft)
                internalCorners.insert(.bottomRight)
            }
        }
        self.bs_roundCorners(internalCorners, radius);
     }
    public func bs_isSuperViewExist(_ view:UIView)->Bool{
      var tempSuperView:UIView?=self
      repeat {
        tempSuperView = tempSuperView?.superview
      }while tempSuperView != view && tempSuperView != nil;
      return !(tempSuperView == nil);
    }
    public func bs_isSuperViewType(_ viewType:UIView.Type)->Bool {
      var tempSuperView:UIView?=self
      repeat {
        tempSuperView = tempSuperView?.superview
      }while (!(tempSuperView?.isKind(of:viewType) ?? false) && tempSuperView != nil)
      return !(tempSuperView == nil);
    }
    // Zoom Animation
    public func bs_zoom(){
        UIView.animate(withDuration: 0.3,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    },
                    completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.transform = CGAffineTransform.identity
                        }
        })
    }
    public func bs_rotate360Degrees(_ duration: CFTimeInterval = 10) {
       self.bs_stopRotating();
       let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
       rotateAnimation.fromValue = -CGFloat.pi
       rotateAnimation.toValue = CGFloat.pi * 1
       rotateAnimation.duration = duration
       rotateAnimation.repeatCount = Float.infinity
       self.layer.add(rotateAnimation, forKey: nil)
   }

    public func bs_stopRotating(){
       self.layer.sublayers?.removeAll()
       //or
       self.layer.removeAllAnimations()
   }
     public class func bs_instanceFromNib(_ nibFileName:String) -> UIView? {
         return UINib(nibName: nibFileName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
     }
     public static func bs_instanceFromNib() -> UIView?{
         let name:String = String(describing: self)
         return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
     }
 }

 /*    **UIResponder**   */

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

 /*    **UIStoryboard**   */

 public extension UIStoryboard {
  static let bs_main : UIStoryboard? = UIStoryboard(name: "Main", bundle: nil);
 }

 /*    **UITabBar**   */

 public extension UITabBar {
      func bs_setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State){
         if let items = self.items {
                // Setting the title text color of all tab bar items:
                for item in items {
                 item.setTitleTextAttributes(attributes, for: state)
                }
         }
     }
     public func bs_removeBarLine(){
         self.shadowImage = UIImage()
         self.backgroundImage = UIImage()
     }
 }
 
 /*    **UILabel**   */

  extension UILabel {
      public var bs_attributedString:[NSAttributedString.Key : Any]{
          let attributes:[NSAttributedString.Key : Any] = [
                  NSAttributedString.Key.font :self.font,
                  NSAttributedString.Key.foregroundColor :self.textColor,
                  NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
                  ]
          return attributes
      }
      public func bs_underlineText(title:String?){
          attributedText = NSAttributedString(string:title ?? "", attributes: bs_attributedString)
      }
      var bs_numberOfVisibleLines: Int {
          let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
          let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
          let charSize: Int = lroundf(Float(self.font.pointSize))
          return rHeight / charSize
      }
 // depend on language
    public func bs_autoTextAliment(){
         let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") //add whatever characters you find English
         var amountOfEnglishChars = 0
         var amountOfNonEnglishChars = 0
         if   self.text != nil && self.text!.count > 0 {
         for char in self.text!.unicodeScalars {
             if characterset.contains(char) {
                 amountOfEnglishChars += 1
             }
             else {
                 amountOfNonEnglishChars += 1
             }
         }
         }
         self.textAlignment = amountOfEnglishChars > amountOfNonEnglishChars ? .left : .right
     }
 //    func bs_oppositeTextAlignment(){
 //
 //        if self.isRightToLeft {
 //            self.textAlignment = .left
 //        }else{
 //            self.textAlignment = .right
 //
 //        }
 //    }
     public func bs_textHeight(withWidth width: CGFloat) -> CGFloat {
         guard let text = text else {
             return 0
         }
         return text.bs_height(withWidth: width, font: font)
     }
     public func bs_attributedTextHeight(withWidth width: CGFloat) -> CGFloat {
         guard let attributedText = attributedText else {
             return 0
         }
         return attributedText.bs_height(withWidth: width)
     }
     public func bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds:Float,miniFontRange:Float,maxFontRange:Float,fontSubtractionValue:Float){
         var newFont = UIFont.bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds: subtractFontValueEveryWorlds, numberOfWorlds: self.text!.bs_worldsCount.bs_float, currentFont: self.font!, miniFontRange: miniFontRange, maxFontRange: maxFontRange, fontSubtractionValue: fontSubtractionValue, lastCharacter:self.text?.last ?? " ")
         if newFont != nil {
             self.font = newFont!;
         }
     }
     public func bs_calculateMaxLines() -> Int {
             let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
             let charSize = font.lineHeight
             let text = (self.text ?? "") as NSString
             let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
             let linesRoundedUp = Int(ceil(textSize.height/charSize))
             return linesRoundedUp
         }
 }
 /*    **UIApplication**   */
  extension UIApplication {
      // swiftUI
      public var bs_swiftUINavigationController:UINavigationController?{
          return UIApplication.shared.bs_window?.rootViewController?.children.first?.children.first as? UINavigationController
      }
      public var bs_window: UIWindow? {
          if #available(iOS 13.0, *) {
              return UIApplication
                  .shared
                  .connectedScenes
                  .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                  .first { $0.isKeyWindow }
          } else {
              return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
          }
     }
     public func bs_openFilesApp(){
         var fileStringUrl = "shareddocuments://"
         if let fileUrl:URL = try? URL(string:fileStringUrl){
             UIApplication.shared.open(fileUrl)
         }
      }
    public func bs_openSetting(){
         let settingsUrl = URL(string: UIApplication.openSettingsURLString)
         if settingsUrl != nil {
         UIApplication.shared.open(settingsUrl!)
         }
     }

    public func bs_openYoutubeLink(_ stringUrl:String?){
         var schemaUrl = URL.init(string:"youtube://\(stringUrl ?? "")");
         if schemaUrl != nil {
             UIApplication.shared.open(schemaUrl!, options:[:]) { (value) in
                 if value == false {
                     var httpsUrl = URL.init(string:"https://\(stringUrl ?? "")");
                     if httpsUrl != nil {
                         UIApplication.shared.open(httpsUrl!, options:[:]) { (value) in
                         }
                     }
                     
                 }
             }
         }else{
             var httpsUrl = URL.init(string:"https://\(stringUrl ?? "")");
             if httpsUrl != nil {
                 UIApplication.shared.open(httpsUrl!, options:[:]) { (value) in
                 }
             }
         }
     }
 //   public func bs_openSocialMediaAccounts(url:URL?){
 //        guard let urlSocialMedia = url else {
 //            UIApplication.shared.bs_rootViewController?.bs_showMessageWithTitle(title:"Common.Error".localize_, message: "Common.CantNotOpenLink".localize_)
 //            return
 //        }
 //        if url?.absoluteString.lowercased().contains("whatsapp") ?? false {
 //        self.bs_openWhatsUp(phoneNumber: url!.lastPathComponent);
 //        }else
 //        if url?.absoluteString.lowercased().contains("facebook.com") ?? false {
 //            self.bs_openFacebook(id: url!.lastPathComponent);
 //        }else
 //        if url?.absoluteString.lowercased().contains("linkedin.com") ?? false {
 //            self.bs_openLinkedIn(id:url!.lastPathComponent);
 //        }else
 //        if url?.absoluteString.lowercased().contains("twitter.com") ?? false {
 //            self.bs_openTwitter(name: url!.lastPathComponent);
 //        }else
 //        if url?.absoluteString.lowercased().contains("instagram.com") ?? false {
 //            self.bs_openInstegram(path: url!.path + "?" + url!.query!);
 //        }else{
 //            self.bs_openHttpLink(url);
 //        }
 //
 //    }
     public func bs_openSocialMediaAccounts(url:URL?){
         if let url:URL=url{
             if url.absoluteString.lowercased().contains("whatsapp") {
                 self.bs_openWhatsUp(phoneNumber: url.lastPathComponent);
             }else
                 if url.absoluteString.lowercased().contains("facebook.com") {
                     self.bs_openFacebook(id: url.paramater("id") ?? url.lastPathComponent);
                 }else
                     if url.absoluteString.lowercased().contains("linkedin.com") {
                         self.bs_openLinkedIn(id:url.lastPathComponent);
                     }else
                         if url.absoluteString.lowercased().contains("twitter.com") {
                             self.bs_openTwitter(name: url.lastPathComponent);
                         }else
                             if url.absoluteString.lowercased().contains("instagram.com") {
                                 self.bs_openInstegram(path: url.path + "?" + (url.query ?? ""));
                             }else{
                                 self.open(url, options: [:], completionHandler: nil)
             }
         }else{
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
         }
     }
     public func bs_openWhatsUp(phoneNumber:String?){
         guard let phoneNumber = phoneNumber else {
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             return
         }
         let fbURLWeb: URL = URL(string:"https://web.whatsapp.com/\(phoneNumber)")!
         let fbURLID: URL = URL(string:"whatsapp://send?phone=\(phoneNumber)")!
         
         if(UIApplication.shared.canOpenURL(fbURLID)){
             // FB installed
             UIApplication.shared.open(fbURLID, options: [:], completionHandler: nil)
         } else {
             // FB is not installed, open in safari
             UIApplication.shared.open(fbURLWeb, options: [:], completionHandler: nil)
         }
     }
    public func bs_openFacebook(id:String?){
         guard let facebookUID = id else {
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             return
         }
         let fbURLWeb: URL = URL(string: "https://www.facebook.com/\(facebookUID)")!
         let fbURLID: URL = URL(string: "fb://profile/\(facebookUID)")!
         
         if(UIApplication.shared.canOpenURL(fbURLID)){
             // FB installed
             UIApplication.shared.open(fbURLID, options: [:], completionHandler: nil)
         } else {
             // FB is not installed, open in safari
             UIApplication.shared.open(fbURLWeb, options: [:], completionHandler: nil)
         }
     }
     public func bs_openLinkedIn(id:String?){
         //https://www.linkedin.com/in/sari-kamail-eljamal-a866b2121/
         guard let linkedinUID = id else {
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             return
         }
         let linkedInURLWeb: URL = URL(string: "https://www.linkedin.com/in/\(linkedinUID)")!
         let linkedInURLID: URL = URL(string: "linkedin://profile/\(linkedinUID)")!
         
         if(UIApplication.shared.canOpenURL(linkedInURLID)){
             // FB installed
             UIApplication.shared.open(linkedInURLID, options: [:], completionHandler: nil)
         } else {
             // FB is not installed, open in safari
             UIApplication.shared.open(linkedInURLWeb, options: [:], completionHandler: nil)
         }
     }
    public func bs_openTwitter(name:String?){
         //https://twitter.com/orta
         guard let twitterName = name else {
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             return
         }
         let twitterURLWeb: URL = URL(string: "https://twitter.com/\(twitterName)")!
         let twitterURLID: URL = URL(string: "twitter://profile/\(twitterName)")!
         
         if(UIApplication.shared.canOpenURL(twitterURLID)){
             // FB installed
             UIApplication.shared.open(twitterURLID, options: [:], completionHandler: nil)
         } else {
             // FB is not installed, open in safari
             UIApplication.shared.open(twitterURLWeb, options: [:], completionHandler: nil)
         }
     }
     
    public func bs_openGooglePlus(path:String?){
         // https://plus.google.com/u/0/100711776131865357077
         // gplus://plus.google.com/u/0/100711776131865357077
         guard let pathString = path else {
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             return
         }
         let googlePlusURLWeb: URL = URL(string: "https://plus.google.com/u/0/\(pathString)")!
         let googlePlusURLID: URL = URL(string: "gplus:plus.google.com/u/0/\(pathString)")!
         
         if(UIApplication.shared.canOpenURL(googlePlusURLID)){
             // FB installed
             UIApplication.shared.open(googlePlusURLID, options: [:], completionHandler: nil)
         } else {
             // FB is not installed, open in safari
             UIApplication.shared.open(googlePlusURLWeb, options: [:], completionHandler: nil)
         }
     }
    public func bs_openInstegram(path:String?){
         //https://www.instagram.com/shehabagency/?utm_source=ig_profile_share&igshid=3xmdz5ko8anq
         guard let pathString = path else {
             Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             return
         }
         let instagramURLWeb: URL = URL(string: "https://www.instagram.com/\(pathString)")!
         let instagramURLID: URL = URL(string: "instagram://www.instagram.com/\(pathString)")!
         
         if(UIApplication.shared.canOpenURL(instagramURLID)){
             // FB installed
             UIApplication.shared.open(instagramURLID, options: [:], completionHandler: nil)
         } else {
             // FB is not installed, open in safari
             UIApplication.shared.open(instagramURLWeb, options: [:], completionHandler: nil)
         }
     }

    public func bs_openHttpLink(_ url:URL?){
         if let tempUrl:URL = url as? URL{
             self.bs_openHttpLink(url?.absoluteString) ;
         }else{
             
         }
     }
     
     public func bs_openHttpLink(_ stringUrl:String?){
         if stringUrl != nil {
             var tempStringURL:String = stringUrl!;
             if stringUrl!.lowercased().hasPrefix("http") ||  stringUrl!.lowercased().hasPrefix("https") {
                 
             }else{
                 tempStringURL = "http://\(tempStringURL)"
             }
             
             guard let url = URL(string:tempStringURL) else {
                 return //be safe
             }
             if UIApplication.shared.canOpenURL(url) {
                 if #available(iOS 10.0, *) {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                 }
             }else{
                 Alert.show(UIApplication.shared.bs_rootViewController,.error(Localize.CantNotOpenLink, nil))
             }
         }else{}
         
     }
     
     public func bs_open(_ stringUrl:String?){
         if let tempStringUrl:String = stringUrl as? String {
             if let url:URL = URL.init(string:tempStringUrl) {
                 self.bs_open(url);
             }else{
                 
             }
         }

         
     }

     public func bs_open(_ url:URL?){
         if url != nil {
             if UIApplication.shared.canOpenURL(url!) {
                 if #available(iOS 10.0, *) {
                     UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                 }
             }
         }
     }

 }


 /*    **UITabBarController**   */

  extension UITabBarController{
     public func bs_setViewController(vc: UIViewController,_ image: UIImage,_ selectedImage:UIImage) {

         vc.tabBarItem = UITabBarItem.init(title:nil, image: image, selectedImage: selectedImage);
         vc.title="";
         vc.tabBarItem.imageInsets=UIEdgeInsets.zero;
         if   self.viewControllers != nil {
         self.viewControllers!.append(vc)
         }else{
             self.viewControllers = [vc];
         }
     }
     func bs_setViewController(index:Int,vc: UIViewController,_ image: UIImage,_ selectedImage:UIImage) {
         
         vc.tabBarItem = UITabBarItem.init(title:nil, image: image, selectedImage: selectedImage);
         vc.title="";
         vc.tabBarItem.imageInsets=UIEdgeInsets.zero;
         if   self.viewControllers != nil {
             self.viewControllers?.insert(vc, at: index);
         }else{
             self.viewControllers = [vc];
         }
     }
     
 }

 /*    **UINavigationController**   */

  extension  UINavigationController {
     public func bs_popViewControllerTo(vc:UIViewController.Type){
         for controller in self.viewControllers {
             if controller.isKind(of: vc) {
                 self.popToViewController(controller, animated: true)
                 break
             }
         }
     }
 }

 /*    **UIColor**   */

  extension UIColor {
    public var bs_red: CGFloat{ return CIColor(color: self).red }
    public var bs_green: CGFloat{ return CIColor(color: self).green }
    public var bs_blue: CGFloat{ return CIColor(color: self).blue }
    public var bs_alpha: CGFloat{ return CIColor(color: self).alpha }

    public static var placeholder: UIColor {
            return UIColor.init(red: 0, green: 0, blue: 0.0980392, alpha: 0.22);
    }
     public class var bs_random: UIColor {
         let red:CGFloat = CGFloat(drand48())
         let green:CGFloat = CGFloat(drand48())
         let blue:CGFloat = CGFloat(drand48())
         
         return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
         
     }
     public var bs_isLight: Bool? {
     return self.isLight();
     }
     public func isLight(threshold: Float = 0.5) -> Bool? {
             let originalCGColor = self.cgColor

             // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
             // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
             let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
             guard let components = RGBCGColor?.components else {
                 return nil
             }
             guard components.count >= 3 else {
                 return nil
             }

             let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
             return (brightness > threshold)
         }
 }

 /*    **UITextView**   */

  extension UITextView {
      public func bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds:Float,miniFontRange:Float,maxFontRange:Float,fontSubtractionValue:Float){
         var newFont = UIFont.bs_subtractLargeFontWithInRange(subtractFontValueEveryWorlds: subtractFontValueEveryWorlds, numberOfWorlds: self.text!.bs_worldsCount.bs_float ?? 0, currentFont: self.font!, miniFontRange: miniFontRange, maxFontRange: maxFontRange, fontSubtractionValue: fontSubtractionValue, lastCharacter:self.text.last ?? " ")
         if newFont != nil {
             self.font = newFont!;
         }
     }
    public func bs_centerText() {
              self.textAlignment = .center
              let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
              let size = sizeThatFits(fittingSize)
              let topOffset = (bounds.size.height - size.height * zoomScale) / 2
              let positiveTopOffset = max(1, topOffset)
              contentOffset.y = -positiveTopOffset
          }
 }
 
 /*    **UICollectionView**   */
 
 public extension UICollectionView{
     func bs_reloadVisibleItems(){
         self.bs_reloadItems(indexPaths: self.indexPathsForVisibleItems)
     }
      func bs_reloadItems(indexPaths:[IndexPath]){
         self.performBatchUpdates({
             self.reloadItems(at: indexPaths)
         }, completion: nil);
     }
      func bs_reloadData(indexPath:IndexPath){
         self.performBatchUpdates({
             self.reloadItems(at:[indexPath])
         }, completion: nil);
     }
      func bs_reloadItem(index:Int){
         self.performBatchUpdates({
             self.reloadItems(at:[IndexPath.init(row: index, section: 0)])
         }, completion: nil);

     }
    public func bs_register(_ identifier:String,_ bundle:Bundle?=nil){
        self.register(UINib.init(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
 }
 /*    **UIAlertController**   */

  extension UIAlertController {
     public enum DisplayType{
     case show
     case build
     }
     public class func bs_showActionSheet(_ display:DisplayType = DisplayType.show,sender:UIView,viewController: UIViewController,_ preferredStyle: UIAlertController.Style = .actionSheet, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void)->UIAlertController {
         let alertViewController = UIAlertController(title: title, message: message, preferredStyle:preferredStyle)
         for (index, (title, style)) in actions.enumerated() {
             let alertAction = UIAlertAction(title: title, style: style) { (_) in
                 completion(index)
             }
             alertViewController.addAction(alertAction)
         }
         alertViewController.popoverPresentationController?.delegate = (viewController as? UIPopoverPresentationControllerDelegate)
         alertViewController.popoverPresentationController?.sourceView = sender
         if display == .show{
         viewController.present(alertViewController, animated: true, completion: nil)
         }
         return alertViewController
     }
    public class func bs_showActionSheet(_ display:DisplayType = DisplayType.show,sender:UIView,viewController:UIViewController?=UIApplication.shared.bs_rootViewController,_ preferredStyle: UIAlertController.Style = .actionSheet,title:String,message:String,cancel:String,objects:[Any]?,converter:(Any)->String,selectHandler:@escaping (Int,Any)->Void,canceldHandler:(()->Void)?)->UIAlertController{
         var actions: [(String, UIAlertAction.Style)] = []
         for object in objects ?? [] {
             actions.append((converter(object), UIAlertAction.Style.default))
         }
         actions.append((cancel, UIAlertAction.Style.cancel))
     var alertViewController = UIAlertController.bs_showActionSheet(display,sender:sender,viewController:viewController!,preferredStyle, title:title, message:message, actions: actions) { (index) in
             if index == objects?.count ?? 0 {
                 // click cancel button
                 canceldHandler?()
             }else{
                 let selectedObject = objects?[index];
                 selectHandler(index,selectedObject);
             }
         }
     return alertViewController
    }
 }
 public extension UINavigationBar{
    // set line for navigation bar
    func defaultStyle(){
        if #available(iOS 13.0, *) {
         let appearance = self.standardAppearance ?? UINavigationBarAppearance()
          let navigationApperance = UINavigationBarAppearance()
          appearance.backgroundEffect = navigationApperance.backgroundEffect
          appearance.shadowColor = navigationApperance.shadowColor
          appearance.backgroundColor = navigationApperance.backgroundColor
          self.standardAppearance = appearance
          self.compactAppearance = appearance
          self.scrollEdgeAppearance = appearance
        }
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.tintColor = UINavigationBar.appearance().tintColor
      }
    
    public func bs_set(backgroundImage:UIImage?,backgroundColor:UIColor?,textAttributes:[NSAttributedString.Key : Any]?,tintColor:UIColor?){
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes=textAttributes ?? [:]
            appearance.largeTitleTextAttributes=textAttributes ?? [:]
            appearance.backgroundColor = backgroundColor
            appearance.backgroundImage = backgroundImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode:.stretch) ?? UIImage()
            self.standardAppearance = appearance
            self.compactAppearance = appearance
            self.scrollEdgeAppearance = appearance

        } else {
        }
        self.titleTextAttributes = textAttributes ?? [:]
        self.setBackgroundImage(backgroundImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode:.stretch) ?? UIImage(), for: .default)
        self.tintColor = tintColor
        self.barTintColor = backgroundColor

    }
    public func bs_setTransparent(backgroundColor:UIColor?,textAttributes:[NSAttributedString.Key : Any]?,tintColor:UIColor?){
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance ?? UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = backgroundColor ?? .clear
            appearance.backgroundEffect = .none
            appearance.shadowColor = .clear
            appearance.titleTextAttributes=textAttributes ?? [:]
            appearance.largeTitleTextAttributes=textAttributes ?? [:]
            self.standardAppearance = appearance
            self.compactAppearance = appearance
            self.scrollEdgeAppearance = appearance
        } else {
        }
        self.titleTextAttributes = textAttributes ?? [:]
        self.tintColor = tintColor
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.barTintColor = backgroundColor ?? .clear
    }
    
     public func bs_removeBarLine(){
         self.setBackgroundImage(UIImage(), for: .default)
         self.shadowImage = UIImage()
     }
 }
 extension UIScrollView{
     public func bs_scrollToBottom(){
         let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)
         self.setContentOffset(bottomOffset, animated: true)
     }
     public func bs_scrollToTop(){
         let bottomOffset = CGPoint(x:0, y:0)
         self.setContentOffset(bottomOffset, animated: true)
     }
     public func bs_isScrollable()->Bool{
         let totalHeight = self.contentSize.height
         if totalHeight > frame.size.height {
             // can scroll more
             return true;
         } else {
            // full content visible
             return false;
         }
     }
    func bs_scrollToView(_ view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
 }

 public extension UIUserInterfaceStyle {
     public var bs_title:String{
         switch self {
         case .unspecified:
             return "UIUserInterfaceStyle.unspecified.bs_title".internalLocalize_;
         case .light:
             return "UIUserInterfaceStyle.light.bs_title".internalLocalize_;
         case .dark:
             return "UIUserInterfaceStyle.dark.bs_title".internalLocalize_;
         }
     }
     public static var bs_all:[UIUserInterfaceStyle]{
         return [.unspecified,.light,.dark]
     }
 }
 
 /*    **UIApplication**   */
 public extension UIApplication{
     var bs_rootNavigationController:UINavigationController?{
       return UIApplication.shared.windows.first?.rootViewController as? UINavigationController;
     }
     var bs_rootViewController:UIViewController?{
       return UIApplication.shared.windows.first?.rootViewController as? UIViewController;
     }
 }
 
 /*    **MPMediaItem**   */
 public extension MPMediaItem{
     class func bs_findSong(_ persistentIDString: String) -> MPMediaItem? {
         let predicate = MPMediaPropertyPredicate(value: persistentIDString, forProperty: MPMediaItemPropertyPersistentID)
         let songQuery = MPMediaQuery()
         songQuery.addFilterPredicate(predicate)

         var song: MPMediaItem?
         if let items = songQuery.items, items.count > 0 {
              song = items[0]
         }
         return song
     }
     var bs_persistentID:NSNumber?{
         return self.value(forProperty: MPMediaItemPropertyPersistentID) as? NSNumber
     }
 }
 #endif
/*    **NSLocale**   */

public extension NSLocale{
    public static func bs_currentLangString(_ defaultEnString:String,_ arString:String)->String{
        let preferredLanguage = NSLocale.preferredLanguages[0]
        if preferredLanguage == "ar"{
            return arString;
        }
        else{
            return defaultEnString;
        }
    }
}

/*    **SystemSoundID**   */

 extension SystemSoundID {
   public static func bs_playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}


/*    **UserDefaults**   */

 extension UserDefaults{
    #if os(iOS)
    private var SelectedAppearance:String{ return "SelectedAppearance"};
        public var bs_selectedAppearance:UIUserInterfaceStyle?{
            set{
                if  let newValue:UIUserInterfaceStyle = newValue , let intNewValue:Int=newValue.rawValue as? Int{
                    UserDefaults.standard.set(intNewValue, forKey:SelectedAppearance)
                    UserDefaults.standard.synchronize();
                    UIApplication.shared.windows.forEach { window in
                        if #available(iOS 13.0, *) {
                            window.overrideUserInterfaceStyle = newValue
                        } else {
                            // Fallback on earlier versions
                        };
                    }
                }
            }
            get{
            let rawValue:Int = UserDefaults.standard.integer(forKey:SelectedAppearance)
            return UIUserInterfaceStyle.init(rawValue:rawValue);
            }
    }
    #endif
     public var bs_appleLanguages:[String]{
        set{
            UserDefaults.standard.set(newValue, forKey: "AppleLanguages");
            UserDefaults.standard.synchronize();
        }
        get {
            var  temp = (UserDefaults.standard.object(forKey: "AppleLanguages") as! [String])
            UserDefaults.standard.synchronize();
            return temp;
        }
    }
     public var bs_appleLanguage:String{
        set {
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages");
            UserDefaults.standard.synchronize();
        }
        get {
            var  temp = (UserDefaults.standard.object(forKey: "AppleLanguages") as! [String])[0]
            UserDefaults.standard.synchronize();
            return temp;
        }
        
    }
}

/*    **CAShapeLayer**   */

 extension CAShapeLayer {
       #if os(iOS)
       @discardableResult public func bs_path(_ path:UIBezierPath) -> Self{
        self.path = path.cgPath
            return self;
        }
       @discardableResult public func bs_fillColor(_ fillColor:UIColor) -> Self{
            self.fillColor = fillColor.cgColor;
            return self;
        }
       #endif
    @discardableResult public func bs_shadowPath() -> Self{
        self.shadowPath = self.path
        return self;
    }
}

/*    **CALayer**   */

 extension CALayer {
    @discardableResult public func bs_shadowOffset(_ shadowOffset:CGSize) -> Self{
        self.shadowOffset = shadowOffset
        return self;
    }
    @discardableResult public func bs_shadowOpacity(_ shadowOpacity:Float) -> Self{
        self.shadowOpacity = shadowOpacity
        return self;
    }
    @discardableResult public func bs_shadowRadius(_ shadowRadius:CGFloat) -> Self{
        self.shadowRadius = shadowRadius
        return self;
    }
    @discardableResult public func bs_shouldRasterize(_ shouldRasterize:Bool) -> Self{
        self.shouldRasterize = shouldRasterize
        return self;
    }
    @discardableResult public func bs_masksToBounds(_ masksToBounds:Bool) -> Self{
        self.masksToBounds = masksToBounds
        return self;
    }
    @discardableResult public func bs_cornerRadius(_ cornerRadius:CGFloat) -> Self{
        self.cornerRadius = cornerRadius
        return self;
    }
    @discardableResult public func bs_borderWidth(_ borderWidth:CGFloat) -> Self{
        self.borderWidth = borderWidth
        return self;
    }
    #if os(iOS)
    public var borderColor_: UIColor {
         get {
             return self.borderColor_
         }
         set {
             self.borderColor = newValue.cgColor
         }
     }
    @discardableResult public func bs_shadowColor(_ shadowColor:UIColor) -> Self{
         self.shadowColor = shadowColor.cgColor;
         return self;
     }
    @discardableResult public func bs_shadowPath(_ shadowPath:UIBezierPath) -> Self{
         self.shadowPath = shadowPath as! CGPath
         return self;
     }
    @discardableResult public func bs_borderColor(_ borderColor:UIColor) -> Self{
        self.borderColor_ = borderColor
        return self;
    }
    #endif
    //cornerRadius
}

/*    **CMTime**   */

 extension CMTime {
     public var bs_duration:String {
        return String.bs_duration(self.seconds);
    }
     public var bs_timeInterval:TimeInterval{
        return TimeInterval.init(self.seconds)
    }
     public var bs_Int:Int?{
        return self.seconds.bs_int
    }
     public var bs_Float:Float {
        
        return Float.init(self.value)
    }
}

/*    **AVPlayer**   */

public extension AVPlayer{
    public var bs_url:URL?{
        return self.currentItem?.asset.bs_url
    }
     public var bs_isPlaying: Bool {
        return rate != 0 && error == nil
    }
     public var bs_durationCMTime: CMTime? { return self.currentItem?.asset.duration}
//     public var bs_duration: TimeInterval { return TimeInterval(self.currentItem?.asset.duration.seconds ?? 0)}
    public var bs_duration: TimeInterval? {
        if let value:TimeInterval = self.currentItem?.asset.duration.seconds{
            return TimeInterval(value);
        }
        return nil;
    }
    // value:current
    func bs_remaining(_ value:Double)->Double?{
        if let duration:TimeInterval=self.bs_duration{
        return duration - value;
        }
        return nil;
    }
     public var bs_itemTitle:String?{
        if let commonMetadata:[AVMetadataItem] = self.currentItem?.asset.commonMetadata{
        if let itemTitle = AVMetadataItem.metadataItems(from:commonMetadata, withKey: AVMetadataKey.commonKeyTitle, keySpace: AVMetadataKeySpace.common).first?.value as? String{
            return itemTitle;
        }
        return nil;
        }
    return nil;
    }
}


/*    **URLComponents**   */

 extension URLComponents {
    public func bs_parameter(paramKey: String) -> String? {
        return self.queryItems?.first(where: { $0.name == paramKey })?.value
    }
}
/*    **URL**   */

extension URL {
    func bs_fileName() -> String {
        return self.deletingPathExtension().lastPathComponent
    }

    func bs_fileExtension() -> String {
        return self.pathExtension
    }
    func paramater(_ paramaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == paramaterName })?.value
    }
}

/*    **MPNowPlayingInfoCenter**   */

 extension MPNowPlayingInfoCenter
{
       public var bs_propertyTitleRemoteControl:String?{
        set{
            self.nowPlayingInfo![MPMediaItemPropertyTitle] = newValue as Any
        }
        get{
            
            return ((self.nowPlayingInfo != nil)&&(self.nowPlayingInfo![MPMediaItemPropertyTitle] != nil)   ? self.nowPlayingInfo![MPMediaItemPropertyTitle] as? String  : nil)
        }
    }
    private(set)  var bs_propertyArtistRemoteControl:String?{
        set{
            self.nowPlayingInfo![MPMediaItemPropertyArtist] = newValue as Any
        }
        get{
            return ((self.nowPlayingInfo != nil)&&(self.nowPlayingInfo![MPMediaItemPropertyArtist] != nil)   ? self.nowPlayingInfo![MPMediaItemPropertyArtist] as? String  : nil)
            
        }
    }
    #if os(iOS)
     public var bs_propertyArtWorkRemoteControl:UIImage?{
        set{
            var art = MPMediaItemArtwork(image: newValue as! UIImage)
            if #available(iOS 10.0, *) {
                art = MPMediaItemArtwork(boundsSize: CGSize(width: 200, height: 200)) { (size) -> UIImage in
                    if newValue != nil{
                        return newValue!;
                    }else{
                        return UIImage.init()
                    }
                }
            }
            
            self.nowPlayingInfo![MPMediaItemPropertyArtwork] = art as Any
        }
        get{
            if self.nowPlayingInfo == nil {
                return nil;
            }
            return (self.nowPlayingInfo![MPMediaItemPropertyArtwork] as! MPMediaItemArtwork).image(at:  CGSize(width: 200, height: 200))
        }
    }
    #endif
     public var bs_propertyPlaybackDurationRemoteControl:TimeInterval?{
        set{
            self.nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] = newValue as Any
        }
        get{
            return ((self.nowPlayingInfo != nil)&&(self.nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] != nil)   ? self.nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] as? TimeInterval  : nil)
        }
    }
      public var bs_propertyElapsedPlaybackTimeRemoteControl:TimeInterval?{
        set{
            self.nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = newValue as Any
        }
        get{
            
            return ((self.nowPlayingInfo != nil)&&(self.nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] != nil)   ? self.nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] as? TimeInterval  : nil)
        }
    }
}

/*    **FloatingPoint**   */

 extension FloatingPoint{
    public func bs_fixedFraction(digits: Int) -> String {
        return String(format: "%.\(digits)f", self as! CVarArg)
    }
    public var bs_isFraction: Bool {
        return !(floor(self) == self)
    }
}

 extension Hashable where Self: AnyObject {
     public var bs_isDictionary:Bool {
        if self is Dictionary<AnyHashable,Any> {
            return true
        }
        return false
    }
     public var bs_isArray:Bool {
        if self is Dictionary<AnyHashable,Any> {
            return true
        }
        return false
    }
//    var bs_type:String{
//    var a = type(of: self);
//        return String.ini
//    }
}
 extension Hashable where Self: Any {
    public var bs_isDictionary:Bool {
        if self is Dictionary<AnyHashable,Any> {
            return true
        }
        return false
    }
    public var bs_isArray:Bool {
        if self is Dictionary<AnyHashable,Any> {
            return true
        }
        return false
    }
}

/*    **Data**   */

 extension Data {
        public enum DataUnits: String {
            case byte, kilobyte, megabyte, gigabyte
        }
        
        public func bs_getSizeIn(_ type: DataUnits)-> (Double?,String?) {
            var size: Double = 0.0
            switch type {
            case .byte:
                size = Double(self.count)
            case .kilobyte:
                size = Double(self.count) / 1024
            case .megabyte:
                size = Double(self.count) / 1024 / 1024
            case .gigabyte:
                size = Double(self.count) / 1024 / 1024 / 1024
            }
            return (size,String(format: "%.2f",size))
        }
    
     public var bs_html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    public var bs_html2String: String {
        return bs_html2AttributedString?.string ?? ""
    }
     public var bs_image:UIImage?{
         return UIImage.init(data: self);
     }
    // used to convert device token from data to base 64 string
    public var bs_64String:String{
        var token:String = "";
        for i in 0..<self.count {
            token = token + String(format: "%02.2hhx", arguments: [self[i]])
        }
        return token;
    }
    public var utf8String:String?{
        return String.init(data:self, encoding:.utf8);
    }
    func bs_toDictionary() -> [String: Any]? {
            do {
                return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        return nil
    }
}

/*    **NSAttributedString**   */

 extension NSAttributedString {
     public func bs_height(withWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
    func bs_targetStyle(_ stringValue:String,
                _ stringAttributes:[NSAttributedString.Key:Any])->NSMutableAttributedString?{
        let initialMutableAttributed = NSMutableAttributedString.init(attributedString: self)
        for range in initialMutableAttributed.string.bs_ranges(of: stringValue){
            let nsRange = NSRange(range, in: initialMutableAttributed.string)
                // Replace content in range with the new content
                let newAttributedString = NSMutableAttributedString(string: stringValue, attributes: stringAttributes)
                initialMutableAttributed.replaceCharacters(in: nsRange, with: newAttributedString)
        }
    return initialMutableAttributed
    }
}

public extension DateFormatter {
    public enum Symbols: String, CustomStringConvertible {
    //example year=1995
    //example month=12
    //example day=09
    //example dayShorNumber=9
    //example hour=01
    //example hourShorNumber=1
    //example minute=55
    //example second=59
    //example clock12=am or am=pm
    //example monthName=September
    //example monthShorName=Sep
    //example weekday=Wednesday
    //example weekdayShortName=Wed
    //example timezone=+0000
    case year = "yyyy"
    case month = "MM"
    case day = "dd"
    case dayShorNumber = "d"
    case hour24System = "HH"
    case hour12System = "hh"
    case hourShorNumber24System = "H"
    case hourShorNumber12System = "h"
    case minute = "mm"
    case minuteShorNumber = "m"
    case second = "ss"
    case clock12 = "a"
    case monthName = "MMMM"
    case monthShorName = "MMM"
    case weekdayName = "EEEE"
    case weekdayShortName = "E"
    case timezone = "Z"
    case monthShorNumber = "M"

    public var description: String {
        return self.rawValue
    }
}
}

/*    **FileManager**   */

public extension FileManager {
    public static let bs_documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    public static let bs_documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    func bs_saveToAppFiles(tempFileUrl:URL,remoteUrl:String?,success:()->(Void),fail:(Error)->(Void)){
        if  let urlString:String = remoteUrl, let fileURL:URL = URL(string:urlString){
            if let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as? URL{
            let destinationFileUrl = documentsUrl.appendingPathComponent(fileURL.lastPathComponent)

                do {
                             if FileManager.default.fileExists(atPath: destinationFileUrl.path){
                                 try FileManager.default.removeItem(at: destinationFileUrl);
                             }
                             try FileManager.default.copyItem(at: tempFileUrl, to: destinationFileUrl)
                    success();
                         } catch (let writeError) {
                            fail(writeError);
                         }
        }
    }
    }
     func bs_writeToFile(_ searchPathDirectory:SearchPathDirectory = .documentDirectory,fileName:String,fileData:Data,completionHandler:(URL?)->Void){
        do {
            let fm = FileManager.default
            guard let docUrl = fm.urls(for:searchPathDirectory, in: .userDomainMask).first else {
                print("Unable to reach the documents folder")
                return
            }
            //fileName=test.mp4
            let localUrl = docUrl.appendingPathComponent(fileName);
            try fileData.write(to: localUrl)
            completionHandler(localUrl)
        } catch  {
            completionHandler(nil)
            print("could not save data")
        }
    }
    func bs_urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
        // folder/subfolder/subfolder
    func bs_createFolder(_ documentDirectory:SearchPathDirectory = .documentDirectory,folderName: String) -> URL? {
            let fileManager = FileManager.default
            // Get document directory for device, this should succeed
            if let documentDirectory = fileManager.urls(for:documentDirectory,
                                                        in: .userDomainMask).first {
                // Construct a URL with desired folder name
                let folderURL = documentDirectory.appendingPathComponent(folderName)
                // If folder URL does not exist, create it
                if !fileManager.fileExists(atPath: folderURL.path) {
                    do {
                        // Attempt to create folder
                        try fileManager.createDirectory(atPath: folderURL.path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                    } catch {
                        // Creation failed. Print error & return nil
                        print(error.localizedDescription)
                        return nil
                    }
                }
                // Folder either exists, or was created. Return URL
                return folderURL
            }
            // Will only be called if document directory not found
            return nil
        }
    func bs_contentsOfDirectory(path:String) ->[String] {
        let docPath = Bundle.main.resourcePath! + "/" + path
        let fileManager = FileManager.default
        do {
            let filesFromBundle:[String] = try fileManager.contentsOfDirectory(atPath: docPath)
            return filesFromBundle;

        } catch {}
        return [];
    }
    public static func bs_removeAllItemsForFolder(_ folder:String,directory: FileManager.SearchPathDirectory = .documentDirectory){
        var documentUrl =  FileManager.default.urls(for:directory, in: .userDomainMask).first
        documentUrl = documentUrl?.appendingPathComponent(folder)

        if let documentsUrl:URL = documentUrl{
        let fileURLs = try? FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: .skipsHiddenFiles)
        for url in fileURLs ?? []{
            do {
                try FileManager.default.removeItem(at: url);
            }catch let error{
                
            }
        }
        }
    }
}

public extension Array where Element == PHAsset {
    
     #if os(iOS)
     func bs_dataPhotos() -> [Data]{
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.isNetworkAccessAllowed=false;
        option.deliveryMode = .highQualityFormat;
        
        var tempArray:[Data] = [Data]();
        for asset in self
        {
            manager.requestImageData(for: asset, options: option, resultHandler: { (data:Data?, string:String?, orientation:UIImage.Orientation, info:[AnyHashable:Any]?) in
            tempArray.append(data!)
            })
        }
        return tempArray;
    }
    
    func bs_photos() -> [UIImage]{
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.isNetworkAccessAllowed=false;
        option.deliveryMode = .highQualityFormat;
        
        var tempArray:[UIImage] = [UIImage]();
        for asset in self
        {
            manager.requestImage(for: asset, targetSize: CGSize.zero, contentMode: .default, options: option) { (img:UIImage?, info:[AnyHashable:Any]?) in
                tempArray.append(img!)

            }
        }
        return tempArray;
    }
     #endif

}

/*    **PHAsset**   */

public extension PHAsset {
    #if os(iOS)
    func bs_photo(photoHanlder:@escaping (UIImage?)->Void){
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        //option.isSynchronous = true
        option.isNetworkAccessAllowed=false;
        option.deliveryMode = .highQualityFormat;
        
        manager.requestImage(for: self, targetSize: CGSize.zero, contentMode: .default, options: option) { (img:UIImage?, info:[AnyHashable:Any]?) in
            photoHanlder(img);
            
        }
    }

    func bs_photoData(dataHandler:@escaping (Data?)->Void){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        //option.isSynchronous = true
        option.isNetworkAccessAllowed=false;
        option.deliveryMode = .highQualityFormat;
        manager.requestImageData(for: self, options: option, resultHandler: { (data:Data?, string:String?, orientation:UIImage.Orientation, info:[AnyHashable:Any]?) in
            dataHandler(data)
        })
    }
    #endif
    func bs_videoData(dataHandler:@escaping (Data?)->Void){
        guard (self.mediaType == .video) else {
            print("Not a valid video media type")
            dataHandler(nil);
            return
        }
        PHImageManager.default().requestAVAsset(forVideo: self, options: nil) { (asset, audioMix, args) in
                   DispatchQueue.main.async {

            if var urlAsset:AVURLAsset = asset as? AVURLAsset {
                    do {
                            var data = try Data.init(contentsOf: urlAsset.url);
                            
                        dataHandler(data);
                    }catch{
                        dataHandler(nil);

                    }
            }else{ dataHandler(nil); }
                 }

        }
    }
    #if os(iOS)
    func bs_openVideoData(presenter:UIViewController){
        guard (self.mediaType == .video) else {
            print("Not a valid video media type")
            return
        }
      PHImageManager.default().requestAVAsset(forVideo: self, options: nil) { (asset, audioMix, args) in
                    DispatchQueue.main.async {
                        if var urlAsset:AVURLAsset = asset as? AVURLAsset {
                            let player = AVPlayer.init(playerItem: AVPlayerItem.init(asset: urlAsset))
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            presenter.present(playerViewController, animated: true) {
                                playerViewController.player!.play()
                            }
                        }
                
                    }

        }
    }
    #endif
}

public extension PHFetchResult where ObjectType == PHAsset {
    open var bs_objects: [ObjectType] {
        var _objects: [ObjectType] = []
        enumerateObjects { (object, _, _) in
            _objects.append(object)
        }
        return _objects
    }
}
public extension PHFetchResult where ObjectType == PHCollection {
    open var bs_objects: [ObjectType] {
        var _objects: [ObjectType] = []
        enumerateObjects { (object, _, _) in
            _objects.append(object)
        }
        return _objects
    }
}
public extension PHFetchResult where ObjectType == PHAssetCollection {
    open var bs_objects: [ObjectType] {
        var _objects: [ObjectType] = []
        enumerateObjects { (object, _, _) in
            _objects.append(object)
        }
        return _objects
    }
}

/*    **PHPhotoLibrary**   */

 extension PHPhotoLibrary {

    public class func bs_creationRequestForAssetFromVideo(atFileURL:URL,completionHandler:@escaping (Bool,AVURLAsset?,Error?)->Void){
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:atFileURL);
        }) { saved, error in
            if saved {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                // After uploading we fetch the PHAsset for most recent video and then get its current location url
                if let fetchResult:PHAsset = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject{
                PHImageManager().requestAVAsset(forVideo: fetchResult, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                    completionHandler(saved,avurlAsset as? AVURLAsset,nil)
                    // This is the URL we need now to access the video from gallery directly.
                })
                }else{
                    completionHandler(saved,nil,nil)
                }
            }else{
                completionHandler(false,nil,error)
            }
        }
    }

    public class func bs_creationRequestForAssetFromVideo(data:Data,completionHandler:@escaping (Bool,AVURLAsset?,Error?)->Void){
        FileManager.default.bs_writeToFile(fileName:"test.mp4", fileData: data) { (atFileURL:URL?) in
            if atFileURL != nil {
                PHPhotoLibrary.bs_creationRequestForAssetFromVideo(atFileURL: atFileURL!, completionHandler: { (saved:Bool,avurlasset:AVURLAsset?, error:Error?) in
                    completionHandler(saved,avurlasset,error);
                })
            }else{
                completionHandler(false,nil,nil);
            }
        }
    }

   public class func bs_checkPhotoLibraryAuthorization(authorized:(()->Void)?,unAuthorized:(()->Void)?){
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            //      getPhotosAndVideos()
            authorized?();
        }else {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    //   self.getPhotosAndVideos()
                    authorized?();
                }else {
                    unAuthorized?();
                }
            })
        }
    }
    
}


/*    **Date**   */

public extension Date {
//        static func bs_splitDatesBy(startDate:Date,endDate:Date,seconds:Int)->[(Date,Date)]{
//            var dates:[(Date,Date)]=[(Date,Date)]();
//            var lastDateAdded:Date=startDate
//            var subtract = 0
//            repeat{
//                var newDate = lastDateAdded;
//                newDate.add(.second, value:seconds)
//                subtract = endDate.seconds(from: newDate);
//                if subtract > seconds{
//                dates.append((lastDateAdded,newDate))
//                lastDateAdded = newDate
//                }
//                else
//                if subtract == 0{
//
//                }
//                else
//                if subtract < seconds {
//                    newDate = lastDateAdded
//                    newDate.add(.second, value:subtract)
//                    lastDateAdded = newDate
//                    print(subtract);
//                }
//
//            }while subtract > 0
//            return dates;
//        }
    func bs_years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }

    func bs_months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }

    func bs_days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func bs_hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func bs_minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }

    func bs_seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    public static func - (lhs: Date, rhs: Date) -> TimeInterval {
           return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
       }
    func bs_compareDateIsSameDay(date:Date) -> Bool {
        // check if same year and same month and same day
        let order = Calendar.current.compare(self, to: date,
                                             toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    func bs_compareDateIsPreviousDay(_ date:Date) -> Bool {
        // check if  year and  month and  day previous or not
        let order = Calendar.current.compare(self, to: date,
                                             toGranularity: .day)
        switch order {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    func bs_startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    func bs_endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.bs_startOfMonth())!
    }
    
    static func bs_daysInThisMonth(date:Date)-> [Date]{
        return Date.bs_dates(from: date.bs_startOfMonth(), to: date.bs_endOfMonth());
    }
    static func bs_dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    static var bs_yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().bs_noon)!
    }
    static var bs_tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().bs_noon)!
    }
    var bs_dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: bs_noon)!
    }
    var bs_dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: bs_noon)!
    }
    var bs_noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var bs_month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var bs_isLastDayOfMonth: Bool {
        return bs_dayAfter.bs_month != bs_month
    }
    func bs_formatter(_ formate:String,calendar:Calendar=Calendar.init(identifier: Calendar.Identifier.gregorian), _ locale:Locale=NSLocale.system)->String{
        let dateFor = DateFormatter()
         dateFor.locale = locale // or "en" as you want to show numbers
         dateFor.calendar = calendar
         dateFor.dateFormat = formate
        return dateFor.string(from: self);
    }
    func bs_islamicFormatter(formate:String, _ locale:Locale=NSLocale.system)->String{
        return self.bs_formatter(formate, calendar: Calendar.init(identifier: Calendar.Identifier.islamicUmmAlQura),locale);
    }
    func bs_gregorianFormatter(formate:String, _ locale:Locale=NSLocale.system)->String{
        return self.bs_formatter(formate, calendar: Calendar.init(identifier: Calendar.Identifier.gregorian),locale);
    }
    static func bs_init(dateString: String, format: String, timeZone: TimeZone?, calendar:Calendar?,locale:Locale=NSLocale.system)->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale;
        dateFormatter.dateStyle = .none;
        dateFormatter.timeStyle = .none;
        if let timeZone:TimeZone=timeZone{
        dateFormatter.timeZone = timeZone;
        }
        dateFormatter.dateFormat = format;
        if let calendar:Calendar=calendar{
        dateFormatter.calendar = calendar;
        }
        guard let date = dateFormatter.date(from: dateString) else {
            return  Date()
        }
        return date;
    }
    
    enum Day:Int{
    case sunday=1
    case monday=2
    case tuesda=3
    case wednesday=4
    case thursday=5
    case friday=6
    case saturday=7
    }
    func bs_isDay(_ day:Day)->Bool{
        let today = self
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: today)

        if components.weekday == day.rawValue {
            print("Hello Monday")
            return true;
        } else {
            print("It's not Monday")
            return false;
        }
    }
}

/*    **UNNotificationSoundName**   */

public extension UNNotificationSoundName{
 var bs_sound:UNNotificationSound{
        return UNNotificationSound(named: self);
    }
}


extension AVPlayer{
    public var bs_isFinish:Bool{
        return self.currentItem?.asset.duration.seconds == self.currentItem?.currentTime().seconds ?? 0
    }
}

extension Locale{
    public static var bs_currentLanguageName:String?{
        let langCode = Bundle.main.preferredLocalizations[0]
        let currentLanguage = ((UserDefaults.standard.value(forKey: "AppleLanguages") as? Array<String>)?.first)
        let locale = Locale(identifier:currentLanguage ?? "")
        if let languageName = locale.localizedString(forLanguageCode: langCode) {
          return languageName
        }
        return nil;
    }
}

extension CGImage {
    private var bs_thresholdModifier: Double {
        0.45
    }

    var bs_isLight: Bool {
        guard let imageData = self.dataProvider?.data else { return false }
        guard let ptr = CFDataGetBytePtr(imageData) else { return false }

        let dataLength = CFDataGetLength(imageData)
        let threshold = Int(Double(self.width * self.height) * bs_thresholdModifier)
        var darkPixelsCount = 0

        for i in stride(from: 0, to: dataLength, by: 4) {
            let r = ptr[i]
            let g = ptr[i + 1]
            let b = ptr[i + 2]
            let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))

            if luminance < 150 {
                darkPixelsCount += 1

                if darkPixelsCount > threshold { return false }
            }
        }
        return true
    }
}
extension Sequence {
 
    /// Return the sequence with all duplicates removed.
    ///
    /// Duplicate, in this case, is defined as returning `true` from `comparator`.
    ///
    /// - note: Taken from stackoverflow.com/a/46354989/3141234
    public func bs_uniqued(comparator: @escaping (Element, Element) throws -> Bool) rethrows -> [Element] {
        var buffer: [Element] = []

        for element in self {
            // If element is already in buffer, skip to the next element
            if try buffer.contains(where: { try comparator(element, $0) }) {
                continue
            }

            buffer.append(element)
        }

        return buffer
    }
}
#if os(OSX)
extension NSResponder {
   public func bs_getParentViewController() -> NSViewController? {
        if self.nextResponder is NSViewController {
            return self.nextResponder as? NSViewController
        } else {
            if self.nextResponder != nil {
                return (self.nextResponder!).bs_getParentViewController()
            }
            else {return nil}
        }
    }
}
#endif

public extension AVRoutePickerView {
    public func bs_present() {
        let routePickerButton = subviews.first(where: { $0 is UIButton }) as? UIButton
        routePickerButton?.sendActions(for: .touchUpInside)
    }
}
public extension AVAsset{
    public var bs_url:URL?{
        return (self as? AVURLAsset)?.url
    }
}

#if os(iOS)
public extension UIWindow {
    func bs_screenShot() -> UIImage? {
        let layer = self.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        return screenshot
    }
}
#endif

public extension Substring{
    var bs_string:String?{
        return String(self);
    }
}
