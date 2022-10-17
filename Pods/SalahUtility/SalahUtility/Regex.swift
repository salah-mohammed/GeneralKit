//
//  Regex.swift
//  SalahUtility
//
//  Created by Salah on 1/26/21.
//  Copyright © 2021 Salah. All rights reserved.
//

open class Regex {
  private var internalExpression: NSRegularExpression?
  private var pattern: String?

    public init(_ pattern: String) {
    self.pattern = pattern
    do {
        self.internalExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    } catch _ {
    
    }
    
  }
    open func matches(input: String) -> Bool {
    let matches = self.internalExpression?.matches(in:input, range:NSMakeRange(0,input.count))
    return (matches?.count ?? 0) > 0
  }
    
    open func replacement(input:String,replacement:String) -> String {
    var output=input;
        output=internalExpression?.stringByReplacingMatches(in: output, options:.reportProgress, range:NSMakeRange(0,input.count), withTemplate: replacement) ?? "";
        return output;
    }
    
//    func replacement(input:String,replacementCharacter:String) -> String {
//        var output=input;
//        let matches = self.internalExpression.matches(in:output, range:NSMakeRange(0,input.count)).first!
//        for matche in [matches] {
//            var  subString = String(input[Range(matche.range, in: input)!])
//            print(subString)
//            print("\n");
//            print(matche.range.length);
//            print("\n");
//
////            var template = "";
////            for index in 0...(matche.range.length-1){
////                template.append(replacementCharacter)
////            }
//            print(output)
//            print("\n");
//            output = self.internalExpression.replacementString(for: matche, in: input, offset:0, template:replacementCharacter)
//            print(output);
//            print("\n");
//        }
//        return output;
//    }
}
