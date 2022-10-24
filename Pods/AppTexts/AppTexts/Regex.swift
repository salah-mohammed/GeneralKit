//
//  Regex.swift
//  SalahUtility
//
//  Created by Salah on 1/26/21.
//  Copyright © 2021 Salah. All rights reserved.
//

class Regex {
  private var internalExpression: NSRegularExpression?
  private var pattern: String?

    public init(_ pattern: String) {
    self.pattern = pattern
    do {
        self.internalExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    } catch _ {
    
    }
    
  }
     func matches(input: String) -> Bool {
    let matches = self.internalExpression?.matches(in:input, range:NSMakeRange(0,input.count))
    return (matches?.count ?? 0) > 0
  }
    
    func replacement(input:String,replacement:String) -> String {
    var output=input;
        output=internalExpression?.stringByReplacingMatches(in: output, options:.reportProgress, range:NSMakeRange(0,input.count), withTemplate: replacement) ?? "";
        return output;
    }
}
