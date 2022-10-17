//
//  Debuger.swift
//  SalahUtility
//
//  Created by Salah on 3/8/21.
//  Copyright © 2021 Salah. All rights reserved.
//

public class Debuger{
    public static let shared: Debuger = { Debuger()} ()
    
    public var items:[String]=[String]();
    public func debugLog(object: Any?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
      #if DEBUG
        let className = (fileName as NSString).lastPathComponent
      var string = "<\(className)> \(functionName) [#\(lineNumber)]| \(object ?? "nil")\n";
      self.items.append(string);
      print(string)
      #endif
        
    }
    public func debugObject(_ object:Any?){
       #if DEBUG
        self.items.append("\(object ?? "nil")");
       #endif

    }
    public func printApi()->String{
        let message = self.items.joined(separator:"       ->>>>>       ");
        self.items.append(message);
        return message;
    }
    public func printItems()->String{
        let message = self.items.joined(separator:"\n");
        self.items.append(message);
        return message;
    }
    public func printItems(join:String)->String{
        let message = self.items.joined(separator:join);
        self.items.append(message);
        return message;
    }
}
